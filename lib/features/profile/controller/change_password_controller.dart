
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_toast.dart';

import '../../../core/common/widgets/loading_widgets.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';

class ChangePasswordController extends GetxController {

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observable booleans for password visibility
  final RxBool isCurrentPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  // Methods to toggle password visibility
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> changePassword() async {

    if(currentPasswordController.text.isEmpty) {
      AppToasts.errorToast(message: 'Current Password is Required',toastGravity: ToastGravity.TOP);
      return;
    }
    if(newPasswordController.text.isEmpty) {
      AppToasts.errorToast(message: 'New Password is Required',toastGravity: ToastGravity.TOP);
      return;
    }
    if(confirmPasswordController.text.isEmpty) {
      AppToasts.errorToast(message: 'Confirm Password is Required',toastGravity: ToastGravity.TOP);
      return;
    }
    if(newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      AppToasts.errorToast(message: 'New & Confirm Password Not Match!',toastGravity: ToastGravity.TOP);
      return;
    }

    final Map<String, dynamic> body = {
      'oldPassword' : currentPasswordController.text.trim(),
      'newPassword' : newPasswordController.text.trim(),
    };


    try {
      LoadingWidget();
      final response = await NetworkCaller().putRequest(
        AppUrls.changePassword,
        token: 'Bearer ${AuthService.token}',
        body: body,
      );
      if (response.isSuccess) {
        HideLoadingWidget();
        AppToasts.successToast(message: 'Password Changed successfully',toastGravity:  ToastGravity.TOP);
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        HideLoadingWidget();
        AppToasts.errorToast(message: response.responseData['message'] ?? 'Password Change successfully',toastGravity: ToastGravity.TOP);
        AppLoggerHelper.error('Failed to change password: ${response.statusCode}');
      }
    } catch (e) {
      HideLoadingWidget();
      AppToasts.errorToast(message: e.toString(),toastGravity: ToastGravity.TOP);
      AppLoggerHelper.error(e.toString());
    } finally {
      HideLoadingWidget();
    }
  }

}