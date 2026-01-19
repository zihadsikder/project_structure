import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_loader.dart';
import '../../../core/common/widgets/app_toast.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final phoneText = TextEditingController();
  final passwordText = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  Future<void> signIn() async {
    final phone = phoneText.text.trim();
    final password = passwordText.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      AppToasts.errorToast(message: 'Please enter phone and password');
      return;
    }

    isLoading.value = true;
    Get.dialog(const AppLoader(), barrierDismissible: false);

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.login,
        body: {
          "email": phone, // assuming phone/email same field
          "password": password,
        },
      );

      if (response.isSuccess) {
        final token = response.responseData['data']?['accessToken'] as String?;
        if (token != null && token.isNotEmpty) {
          await AuthService.saveToken(token);
          Get.offAllNamed(AppRoute.navBar);
          AppToasts.successToast(message: 'Login successful!');
        } else {
          AppToasts.errorToast(message: 'Access token not found');
        }
      } else {
        String message = response.errorMessage ?? 'Login failed';

        switch (response.statusCode) {
          case 401:
            message = 'Invalid phone or password';
            break;
          case 308:
            final email = response.responseData['data']?['email'] as String?;
            if (email != null) {
              Get.offNamed(
                AppRoute.verifyCodeScreen,
                arguments: {'formScreen': AppRoute.loginScreen, 'email': email},
              );
              message = 'Please verify your email first';
            }
            break;
          case 404:
            message = 'Account not found';
            break;
        }

        AppToasts.errorToast(message: message);
      }
    } catch (e) {
      log('Login error: $e');
      AppToasts.errorToast(
        message:
            e.toString().contains('Timeout')
                ? 'Request timed out'
                : 'Something went wrong',
      );
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  @override
  void onClose() {
    phoneText.dispose();
    passwordText.dispose();
    super.onClose();
  }
}
