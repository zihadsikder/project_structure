import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/app_loader.dart';
import 'package:gat/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/logging/logger.dart';

import '../../../routes/app_routes.dart';
import '../presentation/screens/verify_code_screen.dart';


class ForgetPasswordController extends GetxController {
  final emailText = TextEditingController();

  bool _isValidEmail(String email) {
    return email.isNotEmpty && GetUtils.isEmail(email);
  }

  /// Forgot password logic
  Future<void> forgetPass() async {

    String email = emailText.text.trim();

    if (!_isValidEmail(email)) {
      Get.snackbar(
        'Notice',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      Get.dialog(
        Center(
          child: AppLoader(),
        ),
        barrierDismissible: false,
      );

      final Map<String, String> requestBody = {
        'email': email,
      };

      final response = await NetworkCaller()
          .postRequest(AppUrls.forgetPassword, body: requestBody);

      if (response.isSuccess) {
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        if (response.isSuccess == false) {
          AppSnackBar.error(
            'No account found with this email address.',
          );
          log('response: ${response.responseData}');
          log('Response status: ${response.statusCode}');
          log('Response body: ${response.responseData}');
        } else {
          await Get.offAll(
                () => VerifyCodeScreen(),
            arguments: {
              'formScreen': AppRoute.emailVerifyScreen,
              "email": email,
            },
          );
          AppSnackBar.success(
            response.errorMessage ?? 'Check your email address for the OTP.',
          );
        }
      } else {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        AppSnackBar.error(
          response.errorMessage,
        );

        /// Close the dialog after a delay to avoid indefinite loading
        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        });
      }
    } catch (error) {
      AppLoggerHelper.error('Error: $error');

      if (Get.isDialogOpen == true) {
        Get.back();
      }
      AppSnackBar.error(
        'Something went wrong. Please try again later.',
      );
    }
  }
}
