import 'package:flutter/material.dart';

import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:gat/features/authentication/controllers/sing_up_controller.dart';
import 'package:gat/routes/app_routes.dart';

import '../../../../core/common/widgets/custom_button.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/logo_path.dart';
import 'package:get/get.dart';
class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});

   final SingUpController controller = Get.put(SingUpController());

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
                      hintText: 'Enter your full name',
                      controller: controller.nameText,
                    ),
                    SizedBox(height: 16.h),
                    CustomText(text: 'Business Name',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBold),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      hintText: 'Enter your business name',
                      controller: controller.businessNameText,
                    ),
                    SizedBox(height: 16.h),
                    CustomText(text: 'Email',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBold),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      hintText: 'Enter your email address',
                      controller: controller.emailText,
                    ),
                    SizedBox(height: 16.h),
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

                    SizedBox(height: 32.h),
                    CustomButton(
                        text: 'Create Account',
                        onTap: () {
                          _accountCreateSuccess(context);
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
            ))
    );
  }

   Future<void> _accountCreateSuccess(BuildContext context) {
     return showModalBottomSheet(
       context: context,
       backgroundColor: AppColors.textWhite,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
       ),
       builder: (context) {
         return Container(
           padding: EdgeInsets.only(top: 32,bottom: 46, left: 20,right: 20),
           width: double.infinity,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Image.asset(LogoPath.accountSuccess,width: 138.w,height: 138.h),
               SizedBox(height: 20.h),
               CustomText(text: 'Account Successfully Created!',fontSize: 20.sp,fontWeight: FontWeight.w700, color: AppColors.textBold),
               SizedBox(height: 12.h),
               CustomText(text: 'You’ve successfully create your account? Please login to your account.',textAlign: TextAlign.center,fontSize: 14.sp,fontWeight: FontWeight.w400, color: AppColors.textGrey),
               Spacer(),
               CustomButton(
                   text: 'Login Now',
                   onTap: (){
                     Get.offAllNamed(AppRoute.loginScreen);
                   })
             ],
           ),
         );
       },
     );
   }

}
