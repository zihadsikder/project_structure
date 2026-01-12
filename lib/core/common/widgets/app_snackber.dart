import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackBar {
  AppSnackBar._();

  static const Duration _defaultDuration = Duration(seconds: 3);
  static const double _defaultRadius = 16.0;

  static TextStyle get _titleStyle => GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get _messageStyle => GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.9),
  );

  /// Success SnackBar
  static void success(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFF10B981), // Emerald
      icon: Icons.check_circle_rounded,
    );
  }

  /// Error SnackBar
  static void error(String message, {String title = 'Error'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFEF4444), // Red
      icon: Icons.error_rounded,
    );
  }

  /// Warning SnackBar
  static void warning(String message, {String title = 'Warning'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFF59E0B), // Amber
      icon: Icons.warning_rounded,
    );
  }

  /// Info SnackBar
  static void info(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFF3B82F6), // Blue
      icon: Icons.info_rounded,
    );
  }

  /// Modern Toast implementation
  static void toast(String message) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: _messageStyle.copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.black.withOpacity(0.8),
      borderRadius: 100,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    Get.snackbar(
      title,
      message,
      titleText: Text(title, style: _titleStyle),
      messageText: Text(message, style: _messageStyle),
      icon: Icon(icon, color: Colors.white, size: 28),
      backgroundColor: backgroundColor.withOpacity(0.95),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: _defaultRadius,
      duration: _defaultDuration,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text('DISMISS', style: TextStyle(color: Colors.white70)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
