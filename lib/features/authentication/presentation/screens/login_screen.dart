import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gat/core/common/widgets/custom_button.dart';

import 'package:gat/core/common/widgets/custom_text_field.dart';
import 'package:gat/core/utils/constants/app_colors.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:gat/core/utils/constants/logo_path.dart';
import 'package:gat/features/authentication/controllers/login_controller.dart';
import 'package:gat/routes/app_routes.dart';

import '../../../../core/common/widgets/custom_text.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(LogoPath.splashLogo, width: 99.w, height: 75.h),
                    SizedBox(height: 32.h),
                    CustomText(text: 'Login',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBold),
                    SizedBox(height: 4.h),
                    CustomText(text: 'Please login with your GAT account',
                        color: AppColors.textGrey),
                    SizedBox(height: 32.h),
                    CustomText(text: 'Phone Number',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBold),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      hintText: 'Enter your phone number',
                      controller: controller.phoneText,
                    ),
                    SizedBox(height: 16.h),
                    CustomText(text: 'Password',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBold),
                    SizedBox(height: 12.h),
                    Obx(() {
                      return CustomTextField(
                        hintText: 'Enter your password',
                        controller: controller.passwordText,
                        obscureText: controller.obSecureText.value,
                        suffixIcon: GestureDetector(
                          onTap:
                              () =>
                          controller.obSecureText.value =
                          !controller.obSecureText.value,
                          child:
                          controller.obSecureText.value
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
                          Get.toNamed(AppRoute.navBar);
                        }),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(
                              width: double.infinity,
                              height: 1.5,
                              color: Color(0xffE7EAF2)
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            width: 52.w,
                            height: 22.h,
                            color: Color(0xffF6F7F8),
                            child: Center(
                              child: CustomText(text: 'Or',
                                  color: Color(0xff9597A6)),
                            ),
                          ),
                        ), // spacing between lines
                        Flexible(
                          flex: 5,
                          child: Container(
                              width: double.infinity,
                              height: 1.5,
                              color: Color(0xffE7EAF2)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: AppColors.containerBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                              LogoPath.googleLogo, height: 24.h, width: 24.w),
                          SizedBox(width: 12.w),
                          CustomText(text: 'Sign In with Google',
                              color: AppColors.textBold,
                              fontWeight: FontWeight.w600)
                        ],
                      ),
                    ),
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
            ))
    );
  }
}
