import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/custom_text_field.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:gat/features/authentication/controllers/reset_password_controller.dart';
import 'package:gat/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/logo_path.dart';

class ResetPasswordScreen extends StatelessWidget {
   ResetPasswordScreen({super.key});

   final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(LogoPath.splashLogo, width: 99.w, height: 75.h),
            SizedBox(height: 32.h),
            CustomText(text: 'Reset Password',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBold),
            SizedBox(height: 4.h),
            CustomText(text: 'Use a new password with at least 6 characters.',
                color: AppColors.textGrey),
            SizedBox(height: 24.h),
            CustomTextField(
                hintText: 'Enter your new password',
               controller: controller.newPasswordText,
            ),
            SizedBox(height: 8.h),
            CustomTextField(
                hintText: 'Enter your confirm password',
               controller: controller.confirmPassText,
            ),
            Spacer(),
            CustomButton(
                text: 'Change Password',
                onTap: (){
                  Get.offAllNamed(AppRoute.loginScreen);
                })
          ],
        ),
      )),
    );
  }
}
