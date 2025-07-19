import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:gat/features/authentication/controllers/verify_controller.dart';
import 'package:gat/routes/app_routes.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/logo_path.dart';

class VerifyCodeScreen extends StatelessWidget {
   VerifyCodeScreen({super.key});

   final VerifyController controller = Get.put(VerifyController());

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
            CustomText(text: 'Verification Code',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBold),
            SizedBox(height: 4.h),
            CustomText(text: 'A code has been sent to your email',
                color: AppColors.textGrey),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.center,
              child: Pinput(
                length: 6,
                controller: controller.otpText,
                defaultPinTheme: PinTheme(
                  width: 48.w,
                  height: 48.h,
                  textStyle: TextStyle(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite, // Default background
                    border: Border.all(color: Color(0xffB2B2B2), width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 48.w,
                  height: 48.h,
                  textStyle: TextStyle(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFFEDF2),
                    border: Border.all(color: Color(0xff8C2B47), width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                separatorBuilder: (index) => SizedBox(width: 8),
              ),
            ),
            Spacer(),
            CustomButton(
                text: 'Verify',
                onTap: (){
                  Get.offAllNamed(AppRoute.navBar);
                })
          ],
        ),
      )),
    );
  }
}
