import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_loader.dart';
import '../../../core/common/widgets/app_toast.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';
import '../presentation/widgets/sign_up_confirmation_dialog.dart';

class OtpController extends GetxController {
  final otpTEController = TextEditingController();
  final focusNode = FocusNode();

  final secondsRemaining = 300.obs;
  final isResendClickable = false.obs;
  final isLoading = false.obs;

  String? fromScreen;
  String? email;

  Timer? _timer;
  final isButtonEnabled = false.obs; // ← Add this

  void updateOtpValue(String value) {
    isButtonEnabled.value =
        value.length == 6 && value.contains(RegExp(r'^\d+$'));
  }

  @override
  void onInit() {
    super.onInit();
    fromScreen = Get.arguments?['formScreen'];
    email = Get.arguments?['email'];
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    secondsRemaining.value = 300;
    isResendClickable.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isResendClickable.value = true;
        timer.cancel();
      }
    });
  }

  String get countdownText {
    final min = (secondsRemaining.value ~/ 60).toString();
    final sec = (secondsRemaining.value % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6 || !otp.contains(RegExp(r'^\d+$'))) {
      AppToasts.errorToast(message: 'Please enter valid 6-digit OTP');
      return;
    }

    isLoading.value = true;
    Get.dialog(const AppLoader(), barrierDismissible: false);

    try {
      final body = {"email": email, "otp": int.parse(otp)};

      late final response;

      if (fromScreen == AppRoute.signUpScreen ||
          fromScreen == AppRoute.loginScreen) {
        response = await NetworkCaller().postRequest(
          AppUrls.verifySignUpOtp,
          body: body,
        );
      } else {
        response = await NetworkCaller().postRequest(
          AppUrls.verifyForgetPasswordOtp,
          body: body,
        );
      }

      if (response.isSuccess) {
        if (fromScreen == AppRoute.signUpScreen ||
            fromScreen == AppRoute.loginScreen) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (Get.isDialogOpen == true) Get.back();
            showSignupConfirmationDialog();
          });
        } else {
          final accessToken = response.responseData?['data'] as String?;
          if (accessToken != null) {
            Get.offNamed(
              AppRoute.resetPasswordScreen,
              arguments: {"token": accessToken},
            );
          }
        }
      } else {
        String msg = response.errorMessage ?? 'OTP verification failed';

        if (response.statusCode == 408) msg = 'OTP expired. Please resend.';
        if (response.statusCode == 404) msg = 'Incorrect OTP';

        AppToasts.errorToast(message: msg);
      }
    } catch (e) {
      AppLoggerHelper.error('OTP verify error: $e');
      AppToasts.errorToast(message: 'Something went wrong');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  Future<void> resendOtp() async {
    if (email == null || !isResendClickable.value) return;

    isLoading.value = true;
    Get.dialog(const AppLoader(), barrierDismissible: false);

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.resendOtp,
        body: {"email": email},
      );

      if (response.isSuccess) {
        _startCountdown();
        AppToasts.successToast(message: 'OTP resent successfully');
      } else {
        String msg = response.errorMessage;

        if (response.statusCode == 429) msg = 'Too many requests. Try later';

        AppToasts.errorToast(message: msg);
      }
    } catch (e) {
      AppLoggerHelper.error('Resend OTP error: $e');
      AppToasts.errorToast(message: 'Something went wrong');
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpTEController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
