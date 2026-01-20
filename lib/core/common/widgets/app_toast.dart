import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/constants/app_sizer.dart';

import '../../utils/constants/app_colors.dart';

class AppToasts {
  static Future<void> successToast({
    required String message,
    ToastGravity toastGravity = ToastGravity.CENTER,
  }) async {
    await _cancelExistingToasts();
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.success,
      textColor: Colors.white,
      fontSize: 14.sp,
      webBgColor: "#4CAF50",
      webPosition: "center",
      webShowClose: true,
    );
  }

  static Future<void> errorToast({
    required String message,
    ToastGravity toastGravity = ToastGravity.CENTER,
  }) async {
    await _cancelExistingToasts();
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.error,
      textColor: Colors.white,
      fontSize: 14.sp,
      webBgColor: "#F44336",
      webPosition: "center",
      webShowClose: true,
    );
  }

  static Future<void> warningToast({
    required String message,
    ToastGravity toastGravity = ToastGravity.CENTER,
  }) async {
    await _cancelExistingToasts();
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFF59E0B), // Amber/Warning color
      textColor: Colors.white,
      fontSize: 14.sp,
      webBgColor: "#F59E0B",
      webPosition: "center",
      webShowClose: true,
    );
  }

  static Future<void> infoToast({
    required String message,
    ToastGravity toastGravity = ToastGravity.CENTER,
  }) async {
    await _cancelExistingToasts();
    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFF3B82F6), // Blue/Info color
      textColor: Colors.white,
      fontSize: 14.sp,
      webBgColor: "#3B82F6",
      webPosition: "center",
      webShowClose: true,
    );
  }

  static Future<void> _cancelExistingToasts() async {
    await Fluttertoast.cancel();
  }
}
