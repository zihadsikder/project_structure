
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/image_path.dart';
import '../controller/role_selection_controller.dart';

class RoleSelectionScreen extends GetView<RoleSelectionController> {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Choose Your Role',
                  fontSize: 24.sp,

                ),
                SizedBox(height: 4.h),
                CustomText(
                  text:
                  'Select the role that best fits your purpose',
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 24.h),
                Center(child: Image.asset(ImagePath.rolePng)),
                SizedBox(height: 56.h),
                Obx(() => CustomButton(
                  isOutline: true,
                  onTap: () {
                    controller.selectRole("PROVIDER");
                    controller.proceedToSignup();
                  },
                  text: "Service Provider",

                  borderColor: controller.isSelected("PROVIDER")
                      ? AppColors.primary
                      : AppColors.textFormFieldBorder,
                  backgroundColor: controller.isSelected("PROVIDER")
                      ? AppColors.primary
                      : AppColors.white,
                  textColor: controller.isSelected("PROVIDER")
                      ? AppColors.white
                      : AppColors.textPrimary,

                )),
                SizedBox(height: 12.h),
                Obx(() => CustomButton(
                  isOutline: true,
                  onTap: () {
                    controller.selectRole("SEEKER");
                    controller.proceedToSignup();
                  },
                  text: "Service Seeker",
                  borderColor: controller.isSelected("SEEKER")
                      ? AppColors.primary
                      : AppColors.textFormFieldBorder,
                  backgroundColor: controller.isSelected("SEEKER")
                      ? AppColors.primary
                      : AppColors.white,
                  textColor: controller.isSelected("SEEKER")
                      ? AppColors.white
                      : AppColors.textPrimary,

                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}