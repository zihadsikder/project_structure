import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackBar {
  /// Default Configuration
  static const Duration _defaultDuration = Duration(seconds: 3);
  static const EdgeInsets _defaultMargin = EdgeInsets.all(10.0);
  static const double _defaultBorderRadius = 10.0;

  /// Default Text Styles
  static TextStyle get _defaultTitleStyle => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get _defaultMessageStyle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  /// General Show SnackBar Method
  static void show({
    required String title,
    required String message,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    IconData? icon,
    Widget? iconWidget,
    SnackPosition position = SnackPosition.TOP,
    SnackStyle style = SnackStyle.FLOATING,
    Duration duration = _defaultDuration,
    EdgeInsets margin = _defaultMargin,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    bool isDismissible = true,
    double borderRadius = _defaultBorderRadius,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      borderRadius: borderRadius,
      margin: margin,
      padding: const EdgeInsets.all(15.0),
      duration: duration,
      isDismissible: isDismissible,
      snackStyle: style,
      icon: iconWidget ??
          (icon != null
              ? Icon(icon, color: textColor, size: 24)
              : null),
      titleText: Text(title, style: titleStyle ?? _defaultTitleStyle),
      messageText: Text(message, style: messageStyle ?? _defaultMessageStyle),
    );
  }

  /// Error SnackBar
  static void error(String message, {String title = 'Error'}) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.red.withOpacity(0.9),
      icon: Icons.error_outline,
    );
  }

  /// Success SnackBar
  static void success(String message, {String title = 'Success'}) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.green.withOpacity(0.9),
      icon: Icons.check_circle_outline,
    );
  }

  /// Info SnackBar
  static void info(String message, {String title = 'Info'}) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.blue.withOpacity(0.9),
      icon: Icons.info_outline,
    );
  }

  /// Custom Toast (Bottom, GROUNDED style)
  static void toast({
    required String message,
    String? title,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    IconData? icon,
    Widget? iconWidget,
    Duration duration = _defaultDuration,
    SnackStyle style = SnackStyle.GROUNDED,
  }) {
    Get.rawSnackbar(
      snackStyle: style,
      backgroundColor: backgroundColor,
      duration: duration,
      onTap: (_) => Get.closeAllSnackbars(),
      icon: iconWidget ??
          (icon != null
              ? Icon(icon, color: textColor, size: 20)
              : null),
      titleText: title != null
          ? Text(title, style: _defaultTitleStyle)
          : null,
      messageText: Text(message, style: _defaultMessageStyle),
    );
  }

  /// Error Toast
  static void errorToast(String message, {String? title}) {
    toast(
      title: title,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  /// Success Toast
  static void successToast(String message, {String? title}) {
    toast(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  /// Info Toast
  static void infoToast(String message, {String? title}) {
    toast(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info_outline,
    );
  }
}
