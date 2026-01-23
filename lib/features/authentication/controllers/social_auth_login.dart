import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/common/widgets/app_toast.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';

import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/validators/app_validator.dart';
import '../../../routes/app_routes.dart';

class SocialAuthController extends GetxController {
  String fcmToken = "";
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final isSocialLoading = false.obs;
  final isAppleLoading = false.obs;

  /// Get FCM Token Form Firebase
  Future<void> initializeFCMToken() async {
    try {
      // Check if Firebase is initialized before requesting permission
      if (Firebase.apps.isEmpty) {
        log("Firebase is not initialized. Skipping FCM token retrieval.");
        return;
      }

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        // throw Exception("FCM Token is null");
        log("FCM Token is null (possibly due to missing config)");
        return;
      }
      log('<<=================>> FCM Token : $token');
      fcmToken = token;
    } catch (e) {
      log('Error get FCM Token : $e');
      // AppToasts.errorToast(message: "Couldn't initialize push notifications");
    }
  }

  /// sign in apple function
  Future<void> appleLogin() async {
    try {
      isAppleLoading.value = true;

      // Note: Apple Sign In usually requires iOS/macOS, but for development we might want to skip or mock
      if (!Platform.isIOS && !Platform.isMacOS) {
        AppSnackBar.info(
          "Not Supported, Apple Sign-In only works on iOS/macOS devices.",
        );
        isAppleLoading.value = false;
        return;
      }

      // Perform Apple Sign-In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String email = (credential.email ?? "").trim();
      final String name =
          "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim();

      // Load onboarding data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final onboardingName = prefs.getString('onboarding_name')?.trim() ?? name;
      final referralSource = prefs.getString('referral_source')?.trim();
      // Read userGoal as List (backend expects array)
      final userGoals = prefs.getStringList('user_goal') ?? [];

      // Prepare data for backend social login API
      final Map<String, dynamic> body = {
        "socialLoginId": credential.userIdentifier ?? "",
        "email": email,
        "name": onboardingName.isNotEmpty ? onboardingName : name,
        "role": "USER",
        "image": "", // Apple doesn't provide photoURL
        "socialType": "APPLE",
        "fcmToken": fcmToken,
        "idToken":
            credential.identityToken, // Optional if backend verifies token
        "referralSource": referralSource,
        "userGoal": userGoals, // Send as array
      };

      var response = await NetworkCaller().postRequest(
        AppUrls.socialAuth,
        body: body,
      );

      // Apple only provides email/fullName the FIRST time. On later logins these can be null.
      // If backend requires them (e.g. first-time signup without claims), prompt user and retry.
      if (!response.isSuccess &&
          (email.isEmpty || name.isEmpty) &&
          response.statusCode == 400) {
        final result = await _collectMissingAppleInfo(
          initialName: name,
          initialEmail: email,
        );
        if (result == null) {
          isAppleLoading.value = false;
          return;
        }
        body["name"] = result["name"];
        body["email"] = result["email"];
        response = await NetworkCaller().postRequest(
          AppUrls.socialAuth,
          body: body,
        );
      }

      if (response.isSuccess) {
        String? token = response.responseData['data']['accessToken'];
        String userID = response.responseData['data']['id'] ?? "";

        if (token != null && token.isNotEmpty) {
          await AuthService.saveToken(token);
          await AuthService.saveUID(userID);

          // Clear onboarding data from SharedPreferences after successful Apple login
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('onboarding_name');
          await prefs.remove('referral_source');
          await prefs.remove('user_goal');

          AppToasts.successToast(
            message: response.responseData['message'],
            toastGravity: ToastGravity.CENTER,
          );
          Get.offAllNamed(AppRoute.navBar);
        }
      } else {
        // Show actual API error in a nice format
        final errorMsg =
            response.responseData?['message'] ??
            response.errorMessage ??
            'Sign in failed';
        _showAppleLoginError(errorMsg);
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      // Handle Apple-specific errors nicely
      AppLoggerHelper.error(
        "Apple Sign-In Authorization Error: ${e.code} - ${e.message}",
      );
      String userMessage;
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          userMessage = 'Sign in was cancelled';
          break;
        case AuthorizationErrorCode.failed:
          userMessage = 'Sign in failed: ${e.message}';
          break;
        case AuthorizationErrorCode.invalidResponse:
          userMessage = 'Invalid response from Apple: ${e.message}';
          break;
        case AuthorizationErrorCode.notHandled:
          userMessage = 'Sign in not handled: ${e.message}';
          break;
        case AuthorizationErrorCode.notInteractive:
          userMessage = 'Interactive sign in required';
          break;
        case AuthorizationErrorCode.unknown:
        default:
          userMessage = 'Apple Sign-In error: ${e.message}';
      }
      _showAppleLoginError(userMessage);
    } on FirebaseAuthException catch (e) {
      AppLoggerHelper.error("Firebase Auth Error: ${e.code} - ${e.message}");
      _showAppleLoginError('Authentication failed: ${e.message ?? e.code}');
    } catch (e) {
      AppLoggerHelper.error("Error during Apple Login: $e");
      // Extract meaningful error message
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '').trim();
      }
      _showAppleLoginError(errorMessage);
    } finally {
      isAppleLoading.value = false;
    }
  }

  /// Show Apple login error in a nice bottom sheet
  void _showAppleLoginError(String errorMessage) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            const Text(
              'Apple Sign-In Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<Map<String, String>?> _collectMissingAppleInfo({
    required String initialName,
    required String initialEmail,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: initialName);
    final emailController = TextEditingController(text: initialEmail);

    final result = await Get.dialog<Map<String, String>>(
      AlertDialog(
        title: const Text("Complete your details"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            // Make the content scrollable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(labelText: "Full name"),
                  validator: (v) => AppValidator.validateName(v),
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: "Email address"),
                  validator: (v) => AppValidator.validateEmail(v),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Get.back(
                  result: {
                    "name": nameController.text.trim(),
                    "email": emailController.text.trim(),
                  },
                );
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    nameController.dispose();
    emailController.dispose();
    return result;
  }

  /// ------> Social Google Login with Firebase <-----
  // final FirebaseAuth _auth = FirebaseAuth.instance; // REMOVED to prevent crash on init if Firebase missing

  Future<void> googleLogin() async {
    try {
      isSocialLoading.value = true;

      // Safety check for Firebase
      if (Firebase.apps.isEmpty) {
        AppSnackBar.error(
          "Firebase not initialized. Cannot use Google Sign-In.",
        );
        isSocialLoading.value = false;
        return;
      }

      // If the previous Google sign-in attempt selected an account (even if backend rejected it),
      // GoogleSignIn may silently reuse it. Clear cached session so user can pick another account.
      try {
        if (_googleSignIn.currentUser != null) {
          await _googleSignIn.disconnect();
          await _googleSignIn.signOut();
        }
      } catch (_) {
        // Ignore sign-out failures; we still want to attempt sign-in.
      }
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}

      // Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isSocialLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase Credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Firebase returned no user");
      }

      // Load onboarding data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final onboardingName = prefs.getString('onboarding_name')?.trim();
      final referralSource = prefs.getString('referral_source')?.trim();
      // Read userGoal as List (backend expects array)
      final userGoals = prefs.getStringList('user_goal') ?? [];

      // Prepare body for backend
      final body = {
        "socialLoginId": user.uid,
        "email": user.email,
        "name": onboardingName ?? user.displayName,
        "role": "USER",
        "image": user.photoURL ?? '',
        "socialType": "GOOGLE", //  "GOOGLE" | "FACEBOOK" | "APPLE" | "NONE";
        "fcmToken": fcmToken,
        "referralSource": referralSource,
        "userGoal": userGoals, // Send as array
      };

      final response = await NetworkCaller().postRequest(
        AppUrls.socialAuth,
        body: body,
      );

      if (response.isSuccess) {
        String? token = response.responseData['data']['accessToken'];
        String userID = response.responseData['data']['id'] ?? "";

        if (token != null && token.isNotEmpty) {
          await AuthService.saveToken(token);
          await AuthService.saveUID(userID);

          // Clear onboarding data from SharedPreferences after successful Google login
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('onboarding_name');
          await prefs.remove('referral_source');
          await prefs.remove('user_goal');

          // // Trigger WebSocket connection
          // if (Get.isRegistered<WebSocketClient>()) {
          //   Get.find<WebSocketClient>().connect(AppUrls.socketUrl);
          // }
          // // Start real-time services (SSE, WebSocket, offline queue)
          // if (Get.isRegistered<RealTimeService>()) {
          //   Get.find<RealTimeService>().connectAll();
          // }
          AppToasts.successToast(
            message: response.responseData['message'],
            toastGravity: ToastGravity.CENTER,
          );
          Get.offAllNamed(AppRoute.navBar);
        }
      } else {
        if (response.statusCode == 409 &&
            (response.errorMessage.toLowerCase().contains(
                  'different sign-in method',
                ) ||
                response.errorMessage.toLowerCase().contains(
                  'already in use',
                ))) {
          // Clear the cached Google account so the next tap shows account picker.
          try {
            await _googleSignIn.disconnect();
          } catch (_) {}
          try {
            await _googleSignIn.signOut();
          } catch (_) {}
          try {
            await FirebaseAuth.instance.signOut();
          } catch (_) {}

          final email = (user.email ?? googleUser.email).trim();
          await _showGoogleConflictDialog(email: email);
          return;
        }
        AppSnackBar.error(response.errorMessage);
      }
    } catch (e) {
      isSocialLoading.value = false;
      AppLoggerHelper.error('Error during Google Login : $e');
      if (e.toString().contains("null_session")) {
        AppSnackBar.error("Google Sign-In failed: Null session");
      } else {
        AppSnackBar.error("Google Sign-In failed. Check configuration.");
      }
    } finally {
      isSocialLoading.value = false;
    }
  }

  Future<void> _showGoogleConflictDialog({required String email}) async {
    await Get.dialog(
      AlertDialog(
        title: const Text("Account already exists"),
        content: Text(
          email.isNotEmpty
              ? "The email ($email) is already registered with a different sign-in method.\n\nTry another Google account, or sign in using the method you originally used."
              : "This account is already registered with a different sign-in method.\n\nTry another Google account, or sign in using the method you originally used.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (email.isNotEmpty) {
                emailController.text = email;
              }
              Get.back();
            },
            child: const Text("Use email/password"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              // Next attempt will show account chooser because we disconnect/signOut above.
              //await googleLogin();
            },
            child: const Text("Try another Google"),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Continue as Guest - allows browsing without authentication
  final isGuestLoading = false.obs;

  Future<void> continueAsGuest() async {
    try {
      isGuestLoading.value = true;
      await AuthService.setGuestMode(true);
      log('Continuing as guest');
      Get.offAllNamed(AppRoute.navBar);
    } catch (e) {
      AppLoggerHelper.error('Error continuing as guest: $e');
      AppSnackBar.error("Failed to continue as guest");
    } finally {
      isGuestLoading.value = false;
    }
  }

  /// ------> Social Google Login without Firebase <-----
  // Future<void> googleLogin() async {
  //   try {
  //     isSocialLoading.value = true;
  //
  //     // Sign in with Google (no Firebase)
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       isSocialLoading.value = false;
  //       return;
  //     }
  //
  //     // Get authentication details
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //
  //     // Prepare data for backend API
  //     final body = {
  //       "socialLoginId": googleUser.id, // unique Google ID
  //       "email": googleUser.email,
  //       "name": googleUser.displayName ?? "",
  //       "role": "USER",
  //       "image": googleUser.photoUrl ?? "",
  //       "socialType": "GOOGLE", // GOOGLE | APPLE | FACEBOOK | NONE
  //       "fcmToken": fcmToken,
  //       "idToken":
  //           googleAuth
  //               .idToken, // optional (useful if backend verifies Google token)
  //     };
  //
  //     final response = await NetworkCaller().postRequest(
  //       AppUrls.socialAuth,
  //       body: body,
  //     );
  //
  //     if (response.isSuccess) {
  //       String? token = response.responseData['data']['accessToken'];
  //       String userID = response.responseData['data']['id'] ?? "";
  //
  //       if (token != null && token.isNotEmpty) {
  //         await AuthService.saveToken(token);
  //         //await AuthService.saveUID(userID);
  //         AppToasts.successToast(
  //           message: response.responseData['message'],
  //           toastGravity: ToastGravity.CENTER,
  //         );
  //         Get.offAllNamed(AppRoute.navBar);
  //       }
  //     } else {
  //       AppToasts.errorToast(message: response.errorMessage);
  //     }
  //   } catch (e) {
  //     AppLoggerHelper.error("Error during Google Login (no Firebase): $e");
  //     AppToasts.errorToast(message: "$e");
  //   } finally {
  //     isSocialLoading.value = false;
  //   }
  // }
}
