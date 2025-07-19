import 'package:flutter/material.dart';

import '../../utils/constants/app_sizes.dart';
import 'custom_text.dart';
import '../../utils/constants/app_colors.dart';


class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String hintText;
  final bool withAsterisk;
  final List<String> items;
  final String selectedValue;
  final Color? borderColor;
  final ValueChanged<String> onChanged;

  const CustomDropdownField({
    super.key,
    this.label,
    required this.hintText,
    this.withAsterisk = false,
    required this.items,
    required this.selectedValue,
    this.borderColor = const Color(0xffB8B8B8),
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with red asterisk
        // RichText(
        //   text: TextSpan(
        //     children: [
        //       TextSpan(
        //         text: label,
        //         style: GoogleFonts.poppins(
        //           fontSize: getWidth(16),
        //           color: AppColors.formLabel,
        //         ),
        //       ),
        //       if (withAsterisk)
        //         TextSpan(
        //           text: '*',
        //           style: GoogleFonts.poppins(
        //             fontSize: getWidth(14),
        //             color: AppColors.asteriskColor,
        //           ),
        //         ),
        //     ],
        //   ),
        // ),
        //SizedBox(height: getHeight(6)),

        /// Dropdown field with PopupMenu
        Container(
          // height: getHeight(48),
          padding: EdgeInsets.symmetric(
            horizontal: getWidth(18),
            vertical: getHeight(15),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.textFormFieldBorder,
              width: getWidth(1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Selected Value or Hint Text
              CustomText(
                textOverflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
                fontSize: getWidth(14),
                text: selectedValue.isEmpty ? hintText : selectedValue,
                color: selectedValue.isEmpty
                    ? AppColors.textPrimary
                    : AppColors.textPrimary,
              ),

              // Dropdown Icon with PopupMenuButton
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: onChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: BoxConstraints(
                  maxWidth: getWidth(500),
                  maxHeight: getHeight(400),
                ),
                offset: Offset(getWidth(0), getHeight(20)),
                child: Icon(Icons.keyboard_arrow_down, size: getHeight(24)),
                // Popup menu items
                itemBuilder: (context) {
                  return items.map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: item,
                          fontWeight: FontWeight.w500,
                          fontSize: getWidth(16),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}