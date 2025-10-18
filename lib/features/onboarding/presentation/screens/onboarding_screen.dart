
import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';

import 'package:get/get.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/onboarding_controller.dart';

import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnboardingPage(
                image: ImagePath.onb1Png,
                title: "Your Boat, Our Care",
                subtitle: "From quick repairs to full maintenance, find the right professional anytime, anywhere",
                buttonText: "Next",
              ),
              OnboardingPage(
                image: ImagePath.onb2,
                title: "Find Trusted Experts Anytime",
                subtitle: "Connect with verified service providers for boat and yacht repairs",
                buttonText: "Next",
              ),
              OnboardingPage(
                image: ImagePath.onb3,
                title: "Work Done, Pay Securely",
                subtitle: "Book services, chat to confirm details, and pay safely through the app",
                buttonText: "Get Started",
              ),
            ],
          ),
          Positioned(
            bottom: 136,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) => Obx(
                      () => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle,
                      color: controller.selectedPageIndex.value == index
                          ? AppColors.primary
                          : Color(0xffA9A8A8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}