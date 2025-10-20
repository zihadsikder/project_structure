import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';



import '../../../../core/common/widgets/custom_button.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/logo_path.dart';
import 'package:get/get.dart';

import '../../../../core/utils/validators/app_validator.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/sing_up_controller.dart';
class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});

   final SignUpController controller = Get.put(SignUpController());
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
                child: Form(
                  key: _formKey,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(LogoPath.splashLogo, width: 99.w, height: 75.h),
                      SizedBox(height: 32.h),
                      CustomText(text: 'Create Account',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 4.h),
                      CustomText(text: 'Please complete the registration form first.',
                          color: AppColors.textGrey),
                      SizedBox(height: 32.h),
                      CustomText(text: 'Full Name',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        prefixIconPath: Image.asset(IconPath.user),
                        hintText: 'Enter your full name',
                        controller: controller.nameTEController,
                      ),
                      SizedBox(height: 16.h),
                      CustomText(text: 'Business Name',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        hintText: 'Enter your business name',
                        controller: controller.nameTEController,
                      ),
                      SizedBox(height: 16.h),
                      CustomText(text: 'Email',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        prefixIconPath: Image.asset(IconPath.email),
                        hintText: 'Enter your email address',
                        controller: controller.emailTEController,
                        validator: AppValidator.validateEmail,
                      ),
                      SizedBox(height: 16.h),
                      CustomText(text: 'Phone Number',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        hintText: 'Enter your phone number',
                        controller: controller.emailTEController,
                      ),
                      SizedBox(height: 16.h),
                      CustomText(text: 'Password',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      Obx(() {
                        return CustomTextField(
                          prefixIconPath: Image.asset(IconPath.lock),
                          hintText: 'Enter your password',
                          controller: controller.passwordTEController,
                          obscureText: controller.isPasswordVisible.value,
                          suffixIcon: GestureDetector(
                            onTap:
                                () =>
                            controller.isPasswordVisible.value =
                            !controller.isPasswordVisible.value,
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
                      SizedBox(height: 12.h),
                      Obx(() {
                        return CustomTextField(
                          prefixIconPath: Image.asset(IconPath.lock),
                          hintText: 'Re-type Password',
                          controller: controller.confirmPasswordTEController,
                          obscureText: controller.isComPasswordVisible.value,
                          suffixIcon: GestureDetector(
                            onTap: () => controller.isComPasswordVisible.value =
                            !controller.isComPasswordVisible.value,
                            child: controller.isComPasswordVisible.value
                                ? Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.grey,
                            )
                                : Icon(
                              Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please re-type password';
                            }
                            if (value !=
                                controller.passwordTEController.text.trim()) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        prefixIconPath: CountryCodePicker(
                          onChanged: (CountryCode code) {
                            controller.updateSelectedCountry(code);
                          },
                          initialSelection: 'BD',
                          favorite: ['+880', 'US'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: true,
                          alignLeft: true,
                          showFlag: true,
                          showFlagDialog: true,
                          showFlagMain: true,
                          flagWidth: 25,
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          dialogSize: const Size(350, 500),
                          enabled: true,
                        ),

                        hintText: '',
                        suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                      ),
                      SizedBox(height: 32.h),
                      CustomButton(
                          text: 'Create Account',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              controller.signUp();
                            }
                          }),
                      SizedBox(height: 18.h),

                      Align(
                          alignment: Alignment.center,
                          child: CustomText(text: 'Already have an account?',
                              color: AppColors.textPrimary)),
                      SizedBox(height: 8.h),
                      CustomButton(
                          text: 'Login',
                          onTap: () {
                            Get.toNamed(AppRoute.loginScreen);
                          })
                    ],
                  ),
                ),
              ),
            ))
    );
  }



}
