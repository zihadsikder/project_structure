
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/common/widgets/app_toast.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';

import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';

class SocialAuthController extends GetxController {
  String fcmToken = "";
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final isSocialLoading = false.obs;

  /// Get FCM Token Form Firebase
  Future<void> initializeFCMToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      String? token = await FirebaseMessaging.instance.getToken();
      if(token == null) {
        throw Exception("FCM Token is null");
      }
      log('<<=================>> FCM Token : $token');
      fcmToken = token;
    } catch (e) {
      log('Error get FCM Token : $e');
      AppSnackBar.error(

        "Couldn't initialize push notifications",
      );
    }
  }
  /// ------> Social Apple Login without Firebase <-----
  Future<void> appleLogin() async {
    try {
      isSocialLoading.value = true;

      if (!Platform.isIOS && !Platform.isMacOS) {
        AppSnackBar.error( "Apple Sign-In only works on iOS/macOS devices.",
        );
        isSocialLoading.value = false;
        return;
      }

      // Perform Apple Sign-In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Prepare data for backend social login API
      final body = {
        "socialLoginId": credential.userIdentifier ?? "",
        "email": credential.email ?? "",
        "name":
        "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim(),
        "role": "USER",
        "image": "", // Apple doesn’t provide photoURL
        "socialType": "APPLE",
        "fcmToken": fcmToken,
        "idToken": credential.identityToken, // Optional if backend verifies token
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
          //await AuthService.saveUID(userID);
          AppToasts.successToast(
            message: response.responseData['message'],
            toastGravity: ToastGravity.CENTER,
          );
          Get.offAllNamed(AppRoute.navBar);
        }
      } else {
        AppSnackBar.error( response.errorMessage);
      }
    } catch (e) {
      AppLoggerHelper.error("Error during Apple Login: $e");
      AppSnackBar.error( "$e");
    } finally {
      isSocialLoading.value = false;
    }
  }
  /// ------> Social Google Login without Firebase <-----
  Future<void> googleLogin() async {
    try {
      isSocialLoading.value = true;

      // Sign in with Google (no Firebase)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isSocialLoading.value = false;
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Prepare data for backend API
      final body = {
        "socialLoginId": googleUser.id, // unique Google ID
        "email": googleUser.email,
        "name": googleUser.displayName ?? "",
        "role": "USER",
        "image": googleUser.photoUrl ?? "",
        "socialType": "GOOGLE", // GOOGLE | APPLE | FACEBOOK | NONE
        "fcmToken": fcmToken,
        "idToken": googleAuth.idToken, // optional (useful if backend verifies Google token)
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
          //await AuthService.saveUID(userID);
          AppToasts.successToast(
            message: response.responseData['message'],
            toastGravity: ToastGravity.CENTER,
          );
          Get.offAllNamed(AppRoute.navBar);
        }
      } else {
        AppSnackBar.error( response.errorMessage);
      }
    } catch (e) {
      AppLoggerHelper.error("Error during Google Login (no Firebase): $e");
      AppSnackBar.error( "$e");
    } finally {
      isSocialLoading.value = false;
    }
  }
  /// ------> Social Google Login with Firebase <-----
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  //
  // Future<void> googleLogin() async {
  //   try {
  //     isSocialLoading.value = true;
  //
  //     // Google Sign-In
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       isSocialLoading.value = false;
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     // Firebase Credential
  //     final credential = GoogleAuthProvider.credential(
  //       idToken: googleAuth.idToken,
  //       accessToken: googleAuth.accessToken,
  //     );
  //
  //     final userCredential = await _auth.signInWithCredential(credential);
  //     final user = userCredential.user;
  //
  //     if (user == null) {
  //       throw Exception("Firebase returned no user");
  //     }
  //
  //     // Prepare body for backend
  //     final body = {
  //       "socialLoginId": user.uid,
  //       "email": user.email,
  //       "name": user.displayName,
  //       "role": "USER",
  //       "image": user.photoURL ?? '',
  //       "socialType": "GOOGLE", //  "GOOGLE" | "FACEBOOK" | "APPLE" | "NONE";
  //       "fcmToken": fcmToken
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
  //       AppSnackBar.error(response.errorMessage);
  //     }
  //   } catch (e) {
  //     isSocialLoading.value = false;
  //     AppLoggerHelper.error('Error during Google Login : $e');
  //     AppSnackBar.error( "$e");
  //   } finally {
  //     isSocialLoading.value = false;
  //   }
  // }

}