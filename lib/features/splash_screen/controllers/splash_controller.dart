import 'package:get/get.dart';
import 'dart:async';

import '../../../routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    startDelay();
  }

  void startDelay() {
    Timer(Duration(seconds: 2), () {
      Get.offNamed(AppRoute.loginScreen);
    });
  }
}
