import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/app_loader.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_snackber.dart';

import '../../../core/services/network_caller.dart';

import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';
import '../presentation/screens/verify_code_screen.dart';

class SignUpController extends GetxController {
  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController = TextEditingController();
  final TextEditingController referralCodeTEController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isComPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCountry = 'Bangladesh'.obs;
  final RxString selectedDialCode = '880'.obs;
  final RxString selectedCode = 'bn'.obs;
  String fcmToken = '';

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleComPasswordVisibility() {
    isComPasswordVisible.value = !isComPasswordVisible.value;
  }

  void updateSelectedCountry(CountryCode code) {
    selectedCountry.value = code.name ?? '';
    selectedDialCode.value = code.dialCode ?? '';
    selectedCode.value = code.code ?? '';
    print('Country: ${code.name}, Dial: ${code.dialCode}, ISO: ${code.code}');
  }

  /// Initialize Firebase Cloud Messaging and get FCM token
  // Future<void> initializeFCM() async {
  //   try {
  //     await FirebaseMessaging.instance.requestPermission(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //     String? token = await FirebaseMessaging.instance.getToken();
  //     if (token == null || token.isEmpty) {
  //       throw Exception('FCM token is empty');
  //     }
  //     log("📲 FCM Token: $token");
  //     fcmToken = token;
  //   } catch (e) {
  //     log("❌ Error getting FCM Token: $e");
  //   }
  // }

  /// Step 1: Validate form and navigate to referral screen
  Future<void> signUp() async {
    // Validate inputs before proceeding
    if (nameTEController.text.trim().isEmpty ||
        emailTEController.text.trim().isEmpty ||
        passwordTEController.text.trim().isEmpty) {
      AppSnackBar.error('Please fill all fields.');
      return;
    }

    isLoading.value = true;
    Get.dialog(
      Center(child: AppLoader()),
      barrierDismissible: false,
    );

    try {
      final Map<String, dynamic> requestBody = {
        "fullName": nameTEController.text.trim(),
        "email": emailTEController.text.trim(),
        "password": passwordTEController.text.trim(),
      };

      log('SignUp Request Body: $requestBody');

      final response = await NetworkCaller().postRequest(
        AppUrls.register,
        body: requestBody,
      );

      log("SignUp API Response: ${response.responseData}");

      if (response.isSuccess) {
        if (Get.isDialogOpen == true) Get.back();
        Get.to(
              () => VerifyCodeScreen(),
          arguments: {
            'formScreen': AppRoute.signUpScreen,
            'email': emailTEController.text.trim(),
          },
        );
      } else if (response.statusCode == 409) {
        if (Get.isDialogOpen == true) Get.back();
        AppSnackBar.error(
          'Email already exists. Please login or try different email.',
        );
      } else {
        if (Get.isDialogOpen == true) Get.back();
        AppSnackBar.error(
          response.errorMessage ?? 'Something went wrong. Please try again.',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('SignUp Error: $e');
      if (Get.isDialogOpen == true) Get.back();
      AppSnackBar.error(
        e.toString().contains('TimeoutException')
            ? 'Request timed out. Check your internet connection.'
            : 'Something went wrong! Please try again.',
      );
      log("hahaha :   $e");
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen == true) Get.back();
    }
  }



}
