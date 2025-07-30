import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppForMatters {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy')
        .format(date); // Customize the date format as needed
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(amount); // Customize the currency locale and symbol as needed
  }


  String formatDateTime(String? date, String? time) {
    if (date == null || time == null) return '';

    try {
      final combined = DateFormat("yyyy-MM-dd HH:mm").parse("$date $time");
      return DateFormat(
        "MMMM d, y  h:mm a",
      ).format(combined); // e.g., June 28, 2025  10:25 PM
    } catch (e) {
      return "$date $time"; // fallback
    }
  }

  /// pic date
  final dateController = TextEditingController();
  Future<void> pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  /// pic time
  final timeController = TextEditingController();
  Future<void> pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      timeController.text = DateFormat('h:mm a').format(dt); // 5:45 PM format
    }
  }
  static String formatPhoneNumber(String phoneNumber) {
    // Assuming a 10-digit US phone number format: (123) 456-7890
    if (phoneNumber.length == 10) {
      return '(\${phoneNumber.substring(0, 3)}) \${phoneNumber.substring(3, 6)}-\${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(\${phoneNumber.substring(0, 4)}) \${phoneNumber.substring(4, 7)}-\${phoneNumber.substring(7)}';
    }
    // Add more custom phone number formatting logic for different formats if needed.
    return phoneNumber;
  }

}
