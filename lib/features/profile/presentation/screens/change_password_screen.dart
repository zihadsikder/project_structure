
import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/custom_text_field.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_button.dart';

import '../../../../core/common/widgets/custom_text.dart';

import '../../../../core/utils/constants/app_colors.dart';

import '../../../../core/utils/validators/app_validator.dart';
import '../../controller/change_password_controller.dart';


class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final changePasswordController = Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomText(text: 'Change Password', color: AppColors.textPrimary, fontSize: 18,fontWeight: FontWeight.w500,),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Form(
            key: _formKey,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    spacing: 6,

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Password
                      CustomText(
                        text: 'Current Password',
                        fontSize: 16.sp,
                      ),
                      Obx(() => CustomTextField(
                        controller: changePasswordController.currentPasswordController,
                        hintText: 'Enter Current Password',
                        obscureText:
                        !changePasswordController
                            .isCurrentPasswordVisible
                            .value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            changePasswordController
                                .isCurrentPasswordVisible
                                .value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Color(0xFF6C757D),
                          ),
                          onPressed:
                          changePasswordController
                              .toggleCurrentPasswordVisibility,
                        ),
                      ),
                      ),
                      SizedBox(height: 5.h),
                      // New Password
                      CustomText(
                        text: 'New Password',
                        fontSize: 16.sp,
                      ),
                      Obx(() => CustomTextField(
                        controller:
                        changePasswordController.newPasswordController,
                        hintText: 'Enter New Password',
                        obscureText:
                        !changePasswordController.isNewPasswordVisible.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            changePasswordController.isNewPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Color(0xFF6C757D),
                          ),
                          onPressed:
                          changePasswordController
                              .toggleNewPasswordVisibility,
                        ),
                        validator: AppValidator.validatePassword,
                      ),
                      ),
                      SizedBox(height: 5.sp),
                      // Confirm Password
                      CustomText(
                        text: 'Confirm Password',
                        fontSize: 16.sp,
                      ),
                      Obx(() => CustomTextField(
                        controller:
                        changePasswordController.confirmPasswordController,
                        hintText: 'Enter Confirm Password',
                        obscureText:
                        !changePasswordController
                            .isConfirmPasswordVisible
                            .value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            changePasswordController
                                .isConfirmPasswordVisible
                                .value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF6C757D),
                          ),
                          onPressed:
                          changePasswordController
                              .toggleConfirmPasswordVisibility,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please re-type password';
                          }
                          if (value !=
                              changePasswordController.newPasswordController.text.trim()) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),
                      ),
                      SizedBox(height: 36.h),
                    ],
                  ),
                ),
                Spacer(),
                CustomButton(
                  text: 'Change Password',
                  onTap: () {

                    if (_formKey.currentState!.validate()) {
                      changePasswordController.changePassword();
                    }
                  },
                ),
                SizedBox(height: 36.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}