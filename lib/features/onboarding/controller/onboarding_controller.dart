import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  var pageController = PageController();

  bool get isLastPage => selectedPageIndex.value == 2;

  @override
  void onInit() {
    super.onInit();
  }

  void updatePageIndicator(int index) {
    selectedPageIndex.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      // Navigate to the next screen (e.g., role selection screen)
      //Get.offAllNamed(AppRoute.authScreen);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}