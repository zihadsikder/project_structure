import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


import '../../utils/constants/app_colors.dart';
import 'custom_text.dart';

class CustomTimePicker extends StatelessWidget {
  final TextEditingController timeController;
  final Color backgroundColor;
  final Color textColor;

  const CustomTimePicker({
    super.key,
    required this.timeController,
    this.backgroundColor = const Color(0xFF0b1e37),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child:  Icon(CupertinoIcons.clock),
    );
  }

  // Show Time Picker with custom styling
  void _showTimePicker(BuildContext context) {
    TimeOfDay? selectedTime;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 260,
        color: backgroundColor,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: 'Select Time',
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        decorationColor: AppColors.textSecondary
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: CustomText(
                        text: 'Cancel',
                        color: textColor.withOpacity(0.9),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Container(
              height: 0.5,
              color: textColor.withOpacity(0.3),
            ),

            // Time Picker
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    pickerTextStyle: TextStyle(
                      color: textColor,
                      fontSize: 22,
                    ),
                  ),
                  primaryColor: textColor,
                  brightness: Brightness.dark,
                ),
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration.zero,
                  onTimerDurationChanged: (duration) {
                    selectedTime = TimeOfDay(
                      hour: duration.inHours,
                      minute: duration.inMinutes % 60,
                    );
                  },
                  backgroundColor: backgroundColor,
                ),
              ),
            ),
            CupertinoButton(
              child: CustomText(
                text: 'Done',
                color: AppColors.primary,
              ),
              onPressed: () {
                if (selectedTime != null) {
                  // Format and set the time to the controller
                  final formattedTime = _formatTime(selectedTime!);
                  timeController.text = formattedTime;
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Format the selected time into a readable format
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime = DateFormat.jm().format(DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ));
    return formattedTime;
  }
}


/// how to use
// CustomTextField(
// controller: controller.timeTEController,
// hintText: 'time',
// readonly: true,
// suffixIcon:   CustomTimePicker(
//
// timeController: controller.timeTEController,
//
// ),
// ),