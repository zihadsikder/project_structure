import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String hintText;
  final bool withAsterisk;
  final List<String> items;
  final String selectedValue;
  final Color? borderColor;
  final ValueChanged<String> onChanged;
  final TextStyle? textStyle;
  final double height;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const CustomDropdownField({
    super.key,
    this.label,
    required this.hintText,
    this.withAsterisk = false,
    required this.items,
    required this.selectedValue,
    this.borderColor = const Color(0xffB8B8B8),
    required this.onChanged,
    this.textStyle,
    this.height = 48,
    this.borderRadius = 6,
    this.fontSize = 14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = textStyle ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: effectiveTextStyle.copyWith(color: Colors.black87),
              children: [
                if (withAsterisk)
                  TextSpan(
                    text: ' *',
                    style: effectiveTextStyle.copyWith(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor ?? Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display selected value or hint
              Expanded(
                child: Text(
                  selectedValue.isEmpty ? hintText : selectedValue,
                  style: effectiveTextStyle.copyWith(
                    color: selectedValue.isEmpty
                        ? Colors.grey
                        : effectiveTextStyle.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: onChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                itemBuilder: (context) {
                  return items.map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: effectiveTextStyle,
                      ),
                    );
                  }).toList();
                },
                offset: const Offset(0, 40),
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// example

// CustomDropdownField(
// label: 'Gender',
// hintText: 'Select Gender',
// items: ['Male', 'Female', 'Other'],
// selectedValue: selectedGender,
// onChanged: (value) => setState(() => selectedGender = value),
// withAsterisk: true,
// )
