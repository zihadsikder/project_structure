import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/custom_text_field.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:gat/features/authentication/controllers/reset_password_controller.dart';

import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

import '../../../../core/utils/validators/app_validator.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordController controller = Get.put(ResetPasswordController());
  //final SignUpController signController = Get.put(SignUpController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              //Image.asset(LogoPath.logo, width: 160.w, height: 188.h),
              SizedBox(height: 32.h),

              CustomText(text: 'Reset Your Password',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
              SizedBox(height: 4.h),
              CustomText(
                  textAlign: TextAlign.center,
                  text: 'Welcome back! Please enter a new\npassword.',
                  color: AppColors.textSecondary),
              SizedBox(height: 24.h),
              Obx(() {
                return CustomTextField(
                  prefixIconPath: Image.asset(IconPath.email,),
                  hintText: 'Password',
                  controller: controller.passwordTEController,
                  obscureText: controller.isPasswordVisible.value,
                  suffixIcon: GestureDetector(
                    onTap:
                        () =>
                    controller.isPasswordVisible.value,
                    child:
                    controller.isPasswordVisible.value
                        ? Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.grey,
                    )
                        : Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  validator: AppValidator.validatePassword,
                );
              }),
              SizedBox(height: 8.h),

              Obx(() {
                return CustomTextField(
                  prefixIconPath: Image.asset(IconPath.email,),
                  hintText: 'Re-type Password',
                  controller: controller.confirmPasswordTEController,
                  obscureText: controller.isComPasswordVisible.value,
                  suffixIcon: GestureDetector(
                    onTap:
                        () =>
                    controller.isComPasswordVisible.value =
                    !controller.isComPasswordVisible.value,
                    child:
                    controller.isComPasswordVisible.value
                        ? Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.grey,
                    )
                        : Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  ),
                );
              }),
              Spacer(),
              CustomButton(
                  text: 'Change Password',
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      controller.resetPassword();
                    }
                  })
            ],
          ),
        ),
      )),
    );
  }
}
