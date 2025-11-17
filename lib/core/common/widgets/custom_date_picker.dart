import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../utils/constants/app_colors.dart';
import 'custom_text.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController dateController;
  final Color backgroundColor;
  final Color textColor;

  const CustomDatePicker({
    super.key,
    required this.dateController,
    this.backgroundColor = const Color(0xFF0b1e37), // Default secondary background
    this.textColor = Colors.white, // Default text color white
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.calendar),
      onPressed: () => _showDatePicker(context),
    );
  }

  // Show Date Picker with custom styling
  void _showDatePicker(BuildContext context) {
    DateTime? selectedDate;

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
                        text: 'Select Date',
                        color: textColor,
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

            // Date Picker
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: textColor,
                      fontSize: 22,
                    ),
                    pickerTextStyle: TextStyle(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  primaryColor: textColor,
                  brightness: Brightness.dark,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (date) => selectedDate = date,
                  backgroundColor: backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      if (selectedDate != null) {
        dateController.text =
        '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
      }
    });
  }
}
/// how to use

// CustomTextField(
// controller: controller.dateTEController,
// hintText: 'Date',
// readonly: true,
// suffixIcon:  CustomDatePicker(
// dateController: controller.dateTEController,
//
// ),
// ),
