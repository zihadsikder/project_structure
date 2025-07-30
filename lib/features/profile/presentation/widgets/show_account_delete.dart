import 'package:flutter/material.dart';
import 'package:gat/core/common/widgets/custom_button.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/services/Auth_service.dart';
import '../../../../core/utils/constants/app_colors.dart';

void showAccountDeleteDialog(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: AppColors.textWhite,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Account Deletion',
              fontSize: 20.sp,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: 16.h),
            const Divider(thickness: 0.5, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            CustomText(
              text: 'Are you sure delete your account?',
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Get.back();
                    }, text: 'No',

                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomButton(
                    onTap: AuthService.logoutUser,
                    text: 'Yes, Delete',

                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      );
    },
  );
}