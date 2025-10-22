import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/app_loader.dart';
import 'package:gat/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';
import '../presentation/widgets/sign_up_confirmation_dialog.dart';

class OtpController extends GetxController {
  // Text Field Controller
  final TextEditingController otpTEController = TextEditingController();
  final focusNode = FocusNode();
  // Timer state
  final RxInt secondsRemaining = 300.obs;
  final RxBool isClickable = false.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Navigation data
  String? fromScreen;
  String? email;

  Timer? _timer;
  var otpValue = ''.obs;
  var isButtonEnabled = false.obs;
  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?["email"];
    fromScreen = Get.arguments?['formScreen'];
    _startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpTEController.dispose();
    super.onClose();
  }
  void updateOtpValue(String value) {
    otpValue.value = value;
    isButtonEnabled.value = value.length == 6;
  }
  // Countdown logic
  void _startCountdown() {
    if (_timer?.isActive ?? false) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isClickable.value = true;
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    secondsRemaining.value = 300;
    isClickable.value = false;
    _timer?.cancel();
    _startCountdown();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  /// OTP verification
  Future<void> verifyOtp() async {

    if (fromScreen == AppRoute.signUpScreen || fromScreen == AppRoute.loginScreen) {
      showSignupConfirmationDialog();
    } else {
      Get.offNamed(
        AppRoute.resetPasswordScreen,

      );
    }
    //final otpText = otpTEController.text.trim();
    //
    // if (otpText.length != 6 || int.tryParse(otpText) == null) {
    //   AppSnackBar.error('Please enter a valid 6-digit OTP');
    //   return;
    // }
    //
    // final Map<String, dynamic> requestBody = {
    //   "email": email,
    //   "otp": int.parse(otpText),
    // };
    //
    // try {
    //   Get.dialog(
    //     const Center(child: AppLoader()),
    //     barrierDismissible: false,
    //   );
    //
    //   late final dynamic response;
    //
    //   if (fromScreen == AppRoute.signUpScreen || fromScreen == AppRoute.loginScreen) {
    //     response = await NetworkCaller().postRequest(
    //       AppUrls.verifySignUpOtp,
    //       body: requestBody,
    //     );
    //
    //     if (response.isSuccess) {
    //       Future.delayed(const Duration(seconds: 2), () {
    //         if (Get.isDialogOpen ?? false) Get.back();
    //         showSignupConfirmationDialog();
    //       });
    //     } else {
    //       _handleOtpError(response);
    //     }
    //   } else {
    //     response = await NetworkCaller().postRequest(
    //       AppUrls.verifyForgetPasswordOtp,
    //       body: requestBody,
    //     );
    //
    //     if (response.isSuccess) {
    //       final String? accessToken = response.responseData?['data'];
    //       if (accessToken != null) {
    //         await Get.toNamed(
    //           AppRoute.resetPasswordScreen,
    //           arguments: {"token": accessToken},
    //         );
    //       } else {
    //         _handleError('Invalid OTP entered.');
    //       }
    //     } else {
    //       _handleOtpError(response);
    //     }
    //   }
    // } catch (e) {
    //   log("OTP Verification Error: $e");
    //   _handleError('An unexpected error occurred. Please try again.');
    // } finally {
    //   if (Get.isDialogOpen == true) Get.back();
    // }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (email == null) {
      AppLoggerHelper.error('Email is null in resendOtp');
      AppSnackBar.error('Failed to resend OTP. Please try again.');
      return;
    }

    resetTimer();

    try {
      Get.dialog(const Center(child: AppLoader()), barrierDismissible: false);

      final response = await NetworkCaller().postRequest(
        AppUrls.resendOtp,
        body: {"email": email},
      );

      if (Get.isDialogOpen == true) Get.back();

      if (response.isSuccess) {
        AppSnackBar.success('OTP resent successfully. Please check your email.');
      } else {
        final message = response.errorMessage ??
            response.responseData['message'] ??
            'Failed to resend OTP. Please try again.';

        if (response.statusCode == 429) {
          _handleError('Too many requests. Try again later.');
        } else {
          _handleError(message);
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Exception in resendOtp: $e');
      if (Get.isDialogOpen == true) Get.back();
      AppSnackBar.error('Something went wrong while resending OTP.');
    }
  }

  // Handle errors
  void _handleError(String message) {
    if (Get.isDialogOpen ?? false) Get.back();
    AppSnackBar.error(message);
  }

  void _handleOtpError(dynamic response) {
    switch (response.statusCode) {
      case 408:
        _handleError('OTP expired. Please resend.');
        break;
      case 404:
        _handleError('OTP does not match.');
        break;
      default:
        _handleError(response.errorMessage ?? 'OTP verification failed.');
    }
  }
}
