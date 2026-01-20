import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/common/widgets/app_loader.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizer.dart';

import '../../../../core/utils/constants/logo_path.dart';
import '../../controllers/verify_controller.dart';

class VerifyCodeScreen extends StatelessWidget {
  VerifyCodeScreen({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                LogoPath.splashLogo,
                width: 100.w,
                height: 80.h,
              ),
              SizedBox(height: 40.h),

              // Title & Subtitle
              CustomText(
                text: 'Verification Code',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBold,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: 'Enter the code sent to your email',
                fontSize: 14.sp,
                color: AppColors.textGrey,
              ),
              SizedBox(height: 32.h),

              // Pinput (OTP Field)
              Center(
                child: Pinput(
                  length: 6,
                  controller: controller.otpTEController,
                  focusNode: controller.focusNode,

                  defaultPinTheme: PinTheme(
                    width: 52.w,
                    height: 52.h,
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.textSecondary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 52.w,
                    height: 52.h,
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 52.w,
                    height: 52.h,
                    textStyle: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onCompleted: (pin) {
                    controller.verifyOtp(pin);
                  },
                  onChanged: controller.updateOtpValue,
                ),
              ),

              SizedBox(height: 40.h),

              // Resend Timer & Button
              Obx(
                    () => Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: controller.isResendClickable.value
                            ? "Didn't receive code? "
                            : "Resend code in ",
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      if (!controller.isResendClickable.value)
                        CustomText(
                          text: controller.countdownText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      if (controller.isResendClickable.value)
                        GestureDetector(
                          onTap: controller.resendOtp,
                          child: CustomText(
                            text: 'Resend',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Verify Button with Loading
              Obx(
                    () => controller.isLoading.value
                    ? const Center(child: AppLoader(size: 40))
                    : CustomButton(
                  text: 'Verify Code',
                  onTap: controller.isButtonEnabled.value
                      ? () => controller.verifyOtp(controller.otpTEController.text.trim())
                      : null,

                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}