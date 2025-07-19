import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:gat/core/common/widgets/app_loader.dart';
import 'package:gat/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';

class ResetPasswordController extends GetxController {

  final emailText = TextEditingController();
  final otpText = TextEditingController();
  final newPasswordText = TextEditingController();
  final confirmPassText = TextEditingController();
  final isLoading = false.obs;

  String? token;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      token = Get.arguments["token"];
    }
  }

  /// reset Passwor
  Future<void> resetPassword() async {
    final context = Get.context;
    if (newPasswordText.text != confirmPassText.text) {
      AppSnackBar.error(
    'Passwords do not match.',
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      'newPassword': newPasswordText.text.trim(),
    };
    try {
      Get.dialog(
        Center(
            child: AppLoader()),

        barrierDismissible: false,
      );
      String? accessToken = token;
      final response = await NetworkCaller().postRequest(
        AppUrls.resetPassword,
        body: requestBody,
        token: accessToken,
      );
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.back(); // Close loader
      if (response.isSuccess) {
        ///  Success — show dialog
        if (context != null) {
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AuthDialog(message: 'Your account was successfully updated.');
          //   },
          // );

          // Wait for the dialog to be visible, then navigate
          Future.delayed(Duration(seconds: 2), () {
            if (Get.isDialogOpen ?? false) {
              Get.back(); // close dialog
            }
            Get.offAllNamed(AppRoute.signUpScreen);
          });
        }

        log("request $requestBody");
      } else {
        AppSnackBar.errorToast(

          response.errorMessage,
        );
      }

      /// Close the dialog after some time (to prevent indefinite loading)
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      });
    } catch (e) {
      AppLoggerHelper.error('Error: $e');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}