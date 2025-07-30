import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../utils/constants/app_colors.dart';

// ignore: non_constant_identifier_names
LoadingWidget() {
  Get.dialog(
    Center(child: SpinKitCircle(color: AppColors.primary, size: 50.0)),
    barrierDismissible: false,
  );
}

// ignore: non_constant_identifier_names
HideLoadingWidget() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key,  this.size});
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(color: AppColors.primary, size: size ?? 50.0),
    );
  }
}