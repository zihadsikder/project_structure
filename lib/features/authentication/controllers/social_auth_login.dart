
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';

import '../../../routes/app_routes.dart';

class SocialAuthController extends GetxController {

  Future<void> getGoogleUserData() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['openid', 'email'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        debugPrint('User Name: ${googleUser.displayName}');
        debugPrint('User Email: ${googleUser.email}');

        var data = {
          "name": googleUser.displayName,
          "email": googleUser.email,
        };
        final response = await NetworkCaller().postRequest(
          AppUrls.socialAuth,
          body: data,
        );
        if (response.isSuccess) {
          String token = response.responseData['data']['accessToken'];

          if (token.isNotEmpty) {
            await AuthService.saveToken(token);
            Get.offAllNamed(AppRoute.navBar);
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            debugPrint('the response is ${response.responseData}');
            debugPrint('the token is $token');
          }
          debugPrint(
            '========>>>User logged in successfully: ${response.responseData}',
          );
          Get.offAllNamed(AppRoute.navBar);
        } else {
          debugPrint('Error logging in with Google: ${response.errorMessage}');
          AppSnackBar.error(

            'Login failed: ${response.errorMessage}',

          );
        }
      }
    } on PlatformException catch (e) {
      debugPrint('PlatformException Details: ${e.code} - ${e.message} - ${e.details}');
      AppSnackBar.error(

        'Failed to connect to Google Sign-In. Check your configuration.',

      );
    } catch (error) {
      debugPrint('Error signing in with Google: $error');
      AppSnackBar.error(

        'An unexpected error occurred: $error',

      );
    } finally {}
  }

}