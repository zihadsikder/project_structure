import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';


import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routes.dart';

void showSignupConfirmationDialog() {
  Get.dialog(
    AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Color(0xff4CAF50), size: 105),
          Gap(24),
          CustomText(
            textAlign: TextAlign.center,

            text: "Email Successfully\Verified",
          ),
        ],
      ),

      actions: [
        CustomButton(
          text: "Login",
          onTap: () {
            Get.offAllNamed(AppRoute.loginScreen);
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.white,
    ),
  );
}
