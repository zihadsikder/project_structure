import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_toast.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../routes/app_routes.dart';
import '../presentation/screens/verify_code_screen.dart';

class ForgetPasswordController extends GetxController {
  final emailText = TextEditingController();
  final isLoading = false.obs;

  bool get isValidEmail =>
      emailText.text.trim().isNotEmpty &&
      GetUtils.isEmail(emailText.text.trim());

  Future<void> forgetPassword() async {
    final email = emailText.text.trim();

    if (!isValidEmail) {
      AppToasts.errorToast(message: 'Please enter a valid email');
      return;
    }

    isLoading.value = true;

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.forgetPassword,
        body: {'email': email},
      );

      if (response.isSuccess) {
        Get.to(
          () => VerifyCodeScreen(),
          arguments: {'formScreen': AppRoute.emailVerifyScreen, 'email': email},
        );
        AppToasts.successToast(message: 'OTP sent to your email');
      } else {
        String msg = response.errorMessage;

        if (response.statusCode == 404)
          msg = 'No account found with this email';

        AppToasts.errorToast(message: msg);
      }
    } catch (e) {
      AppToasts.errorToast(message: 'Something went wrong. Please try again');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailText.dispose();
    super.onClose();
  }
}
