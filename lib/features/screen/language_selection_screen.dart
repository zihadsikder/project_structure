
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_text.dart';
import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_sizer.dart';
import '../../../core/localization/reusable_language_tile.dart';
import '../../../core/localization/language_controller.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: CustomText(
          text: 'Language',
          fontSize: 20,
          color: AppColors.textWhite,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(
              text: 'Select your language',
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(16.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                buildLanguageTile("English", "en"),
                Gap(8),
                buildLanguageTile("Spanish", "es"),
              ],
            ),
          ),

          const Spacer(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
            child: CustomButton(
              text: 'Next',
              onTap: () {
                if (controller.selectedLanguage.value.isEmpty) {
                  Get.snackbar("Error", "Please select a language");
                } else {
                  // navigate to next screen
                   //Get.toNamed(AppRoute.onboardingScreen);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
