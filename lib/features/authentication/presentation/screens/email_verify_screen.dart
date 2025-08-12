import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/custom_button.dart';
import 'package:gat/core/common/widgets/custom_text_field.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:gat/features/authentication/controllers/reset_password_controller.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/logo_path.dart';
import '../../controllers/forget_pass_controller.dart';

class EmailVerifyScreen extends StatelessWidget {
   EmailVerifyScreen({super.key});

   final ForgetPasswordController controller = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(LogoPath.splashLogo, width: 99.w, height: 75.h),
                SizedBox(height: 32.h),
                CustomText(text: 'Email',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBold),
                SizedBox(height: 4.h),
                CustomText(text: 'Please enter your email for reset password',
                    color: AppColors.textGrey),
                SizedBox(height: 16.h),
                CustomTextField(
                    hintText: 'Email',
                  controller: controller.emailText,
                ),
                Spacer(),
                CustomButton(
                    text: 'Continue',
                    onTap: controller.forgetPass)
              ],
            ),
          )),
    );
  }
}
