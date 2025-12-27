
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../routes/app_routes.dart';
import '../presentation/screens/verify_code_screen.dart';


class ForgetPasswordController extends GetxController {
  final emailText = TextEditingController();
  final isLoading = false.obs;

  bool get isValidEmail => emailText.text.trim().isNotEmpty && GetUtils.isEmail(emailText.text.trim());

  Future<void> forgetPassword() async {
    final email = emailText.text.trim();

    if (!isValidEmail) {
      AppSnackBar.error('Please enter a valid email');
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
          arguments: {
            'formScreen': AppRoute.emailVerifyScreen,
            'email': email,
          },
        );
        AppSnackBar.success('OTP sent to your email');
      } else {
        String msg = response.errorMessage ?? 'Failed to send OTP';

        if (response.statusCode == 404) msg = 'No account found with this email';

        AppSnackBar.error(msg);
      }
    } catch (e) {
      AppSnackBar.error('Something went wrong. Please try again');
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
