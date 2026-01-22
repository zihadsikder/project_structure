import 'dart:io';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';



import '../../../../core/common/widgets/auth_divider.dart';
import '../../../../core/common/widgets/auth_primary_button.dart';
import '../../../../core/common/widgets/auth_social_button.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/localization/app_texts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/logo_path.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/social_auth_login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final SocialAuthController socialAuthController = Get.put(SocialAuthController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 32.h),

                      CustomText(text: 'Login',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 4.h),
                      CustomText(text: 'Please login with your account',
                          color: AppColors.textGrey),
                      SizedBox(height: 32.h),
                      CustomText(text: 'Email',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        hintText: 'Enter your email',
                        controller: controller.phoneText,
                        validator: (value) =>
                            AppValidator.validateEmail(value),
                      ),
                      SizedBox(height: 16.h),
                      CustomText(text: 'Password',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBold),
                      SizedBox(height: 12.h),
                      Obx(() {
                        return CustomTextField(
                          prefixIconPath: Image.asset(IconPath.lock,color: AppColors.textFormFieldBorder,),
                          hintText: AppText.enterYourPassword.tr,
                          controller: controller.passwordText,
                          obscureText: controller.isPasswordHidden.value,
                          suffixIcon: GestureDetector(
                            onTap:
                                () =>
                            controller.isPasswordHidden.value =
                            !controller.isPasswordHidden.value,
                            child:
                            controller.isPasswordHidden.value
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
                      SizedBox(height: 8.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoute.emailVerifyScreen);
                          },
                          child: CustomText(
                            text: 'Forgot Password?',
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      CustomButton(

                          text: 'Login',
                          onTap: () {
                            controller.signIn();
                          }),
                      // Sign In Button
                      Obx(
                            () => AuthPrimaryButton(
                          text: AppText.signIn,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.signIn();
                            }
                          },
                          animationIndex: 3,
                        ),
                      ),

                      SizedBox(height: 32.h),
                      // Or Divider
                      const AuthDivider(animationIndex: 4),
                      SizedBox(height: 32.h),
                      Platform.isAndroid
                          ? Obx(
                            () =>
                            socialAuthController.isSocialLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                            : CustomButton(
                          text: 'Continue with Google',
                          textColor: AppColors.textPrimary,
                          isOutline: true,
                              backgroundColor: Colors.transparent,
                          onTap: () {
                            /// Implement Google login functionality
                            socialAuthController.googleLogin();
                          },
                          prefixIcon: Image.asset(LogoPath.googleLogoPng),
                        ),
                      )
                          : SizedBox.shrink(),
                      Gap(6.h),

                      Platform.isIOS
                          ? Obx(
                            () =>
                            socialAuthController.isSocialLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                            : CustomButton(

                          text: 'Continue with Apple',
                          textColor: AppColors.textPrimary,
                          isOutline: true,
                          backgroundColor: Colors.transparent,
                          onTap: () {
                            /// Implement Google login functionality
                            socialAuthController.appleLogin();
                          },
                          prefixIcon: Image.asset(LogoPath.appleLogo,height: 24,),
                        ),
                      )  : SizedBox.shrink(),
                      // Google Sign In
                      Obx(
                            () => AuthSocialButton(
                          text: 'Continue with Google',
                          iconPath: LogoPath.googleLogoPng,
                          isLoading: socialAuthController.isSocialLoading.value,
                          onPressed: () => socialAuthController.googleLogin(),
                          animationIndex: 5,
                        ),
                      ),

                      // Apple Sign In (iOS only)
                      if (Platform.isIOS) ...[
                        const SizedBox(height: 12),
                        Obx(
                              () => AuthSocialButton(
                                text: 'Continue with Apple',
                            iconPath: LogoPath.appleLogo,
                            isLoading: socialAuthController.isAppleLoading.value,
                            onPressed: () => socialAuthController.appleLogin(),
                            animationIndex: 6,
                          ),
                        ),
                      ],

                      SizedBox(height: 18.h),

                      Align(
                          alignment: Alignment.center,
                          child: CustomText(text: 'Doesn’t have account?',
                              color: AppColors.textPrimary)),
                      SizedBox(height: 8.h),
                      CustomButton(
                          text: 'Register',
                          onTap: () {
                            Get.toNamed(AppRoute.signUpScreen);
                          })
                    ],
                  ),
                ),
              ),
            ))
    );
  }
}
