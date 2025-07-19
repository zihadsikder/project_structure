import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/logo_path.dart';
import '../../controllers/splash_controller.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen ({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(LogoPath.splashLogo),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
