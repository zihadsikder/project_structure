
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/custom_text.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String buttonText;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      //fit: StackFit.expand,
      children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              CustomText(
                textAlign: TextAlign.center,
                text: title,

                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 400,

                  child: image.toLowerCase().endsWith(".svg") ?  SvgPicture.asset(image) : Image.asset(image)),
              CustomText(
                textAlign: TextAlign.center,
                text: subtitle,
                color: AppColors.textSecondary,
              ),

            ],
          ),
        ),

        Positioned(
          bottom: 56,
          left: 24,
          right: 24,


          child:   CustomButton(
          onTap: () => Get.find<OnboardingController>().nextPage(),
          text: buttonText,
        ),)
      ],
    );
  }
}