import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/app_loader.dart';
import 'package:gat/core/utils/constants/app_urls.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final TextEditingController otpTEController = TextEditingController();
  final RxInt secondRemaining = 300.obs;
  final RxBool isClickable = false.obs;
  final RxBool isLoading = true.obs;
  String? fromScreen;
  String? email;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      email = Get.arguments["email"];
      fromScreen = Get.arguments['formScreen'];
    }
    _startCountdown();
  }

  void _startCountdown() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondRemaining.value > 0) {
        secondRemaining.value--;
      } else {
        isClickable.value = true;
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    secondRemaining.value = 300;
    isClickable.value = false;
    _timer?.cancel();
    _startCountdown();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// OTP Verification
  Future<void> verifyOtp() async {
    if (otpTEController.text.isEmpty || otpTEController.text.length != 4) {
      AppSnackBar.error('Please enter a valid 4-digit OTP');
      return;
    }

    final Map<String, dynamic> requestBody = {
      "email": email,
      'otp': otpTEController.text.trim(),
    };

    try {
      Get.dialog(
        const Center(child: AppLoader()),
        barrierDismissible: false,
      );

      late final dynamic response;

      if (fromScreen == AppRoute.signUpScreen || fromScreen == AppRoute.loginScreen) {
        response = await NetworkCaller().postRequest(
          AppUrls.verifySignUpOtp,
          body: requestBody,
        );

        if (response.isSuccess) {
          Future.delayed(const Duration(seconds: 2), () {
            if (Get.isDialogOpen ?? false) Get.back();
            Get.offAllNamed(AppRoute.signUpScreen);
          });
        } else {
          _handleOtpError(response);
        }
      } else {
        response = await NetworkCaller().postRequest(
          AppUrls.verifyForgetPasswordOtp,
          body: requestBody,
        );

        if (response.isSuccess) {
          final String? accessToken = response.responseData?['result']?['forgetToken'];
          if (accessToken != null) {
            await Get.toNamed(
              AppRoute.resetPasswordScreen,
              arguments: {"token": accessToken},
            );
          } else {
            _handleError('Invalid OTP entered.');
          }
        } else {
          _handleOtpError(response);
        }
      }
    } catch (e) {
      log("OTP Verification Error: $e");
      _handleError('An unexpected error occurred. Please try again.');
    } finally {
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    resetTimer();

    final Map<String, dynamic> requestBody = {"id": email};

    if (email == null) {
      AppLoggerHelper.error('Email is null in resendOtp');
      AppSnackBar.error('Failed to resend OTP. Please try again.');
      return;
    }

    try {
      Get.dialog(
        const Center(child: AppLoader()),
        barrierDismissible: false,
      );

      final response = await NetworkCaller().postRequest(
        AppUrls.resendOtp,
        body: requestBody,
      );

      if (Get.isDialogOpen == true) Get.back();

      if (response.isSuccess) {
        AppSnackBar.error(
      'OTP resent successfully. Please check your email.',
        );
      } else {
        String errorMessage = response.errorMessage ??
            (response.responseData['message'] as String? ??
                'Failed to resend OTP. Please try again.');

        if (response.statusCode == 429) {
          errorMessage = 'Too many requests. Please try again later.';
        }

        AppLoggerHelper.error('Resend OTP Error: $errorMessage');
        AppSnackBar.error(errorMessage);
      }
    } catch (e) {
      AppLoggerHelper.error('Exception in resendOtp: $e');
      if (Get.isDialogOpen == true) Get.back();
      AppSnackBar.error(
     'Something went wrong while resending OTP. Please try again.',
      );
    } finally {
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  /// Error Handling
  void _handleError(String errorMessage) {
    if (Get.isDialogOpen ?? false) Get.back();
    AppSnackBar.error(errorMessage);
  }

  void _handleOtpError(dynamic response) {
    if (response.statusCode == 408) {
      _handleError('OTP Expired');
    } else if (response.statusCode == 404) {
      _handleError('OTP doesn\'t match');
    } else {
      _handleError('OTP verification failed.');
    }
  }
}
