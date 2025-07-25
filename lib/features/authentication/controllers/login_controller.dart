import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_urls.dart';
import 'package:gat/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_loader.dart';
import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';

class LoginController extends GetxController {
  final phoneText = TextEditingController();
  final passwordText = TextEditingController();

  final isNewPasswordHidden = true.obs;
  final RxBool obSecureText = true.obs;

  void togglePasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  /// Sign in function
  Future<void> signIn({required String fcmToken}) async {
    if (phoneText.text.trim().isEmpty || passwordText.text.trim().isEmpty) {
      AppSnackBar.error('Please fill all fields.');
      return;
    }

    try {
      Get.dialog(
        const AppLoader(),
        barrierDismissible: false,
      );

      final requestBody = {
        "email": phoneText.text.trim(),
        "password": passwordText.text.trim(),
        "fcmToken": fcmToken,
      };

      log('Login Request Body: $requestBody');

      final response = await NetworkCaller().postRequest(
        AppUrls.login,
        body: requestBody,
      );

      log('Login API Response: ${response.responseData}');

      if (response.isSuccess) {
        final token = response.responseData['result']['accessToken'] ?? '';

        if (token.isNotEmpty) {
          await AuthService.saveToken(token);
          Get.offAllNamed(AppRoute.navBar);
        } else {
          AppSnackBar.error('Access token not found.');
        }
      } else if (response.statusCode == 401) {
        AppSnackBar.error('Invalid credentials. Please try again.');
      } else if (response.statusCode == 308) {
        final email = response.responseData['result']['email'];
        Get.offAllNamed(
          AppRoute.verifyCodeScreen,
          arguments: {
            'formScreen': AppRoute.signUpScreen,
            'email': email,
          },
        );
        AppSnackBar.error(response.errorMessage ?? 'Please verify your email.');
      } else {
        AppSnackBar.error(response.errorMessage ?? 'Something went wrong!');
      }
    } catch (e) {
      log('Login Exception: $e');
      AppSnackBar.error(
        e.toString().contains('TimeoutException')
            ? 'Request timed out. Please check your internet connection.'
            : 'An unexpected error occurred.',
      );
    } finally {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

}
