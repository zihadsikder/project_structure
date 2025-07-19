import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIconPath;
  final Function(String)? onFieldSubmit;
  final bool readonly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final int? maxLines;
  final InputBorder? focusedBorder;
  final Color? containerColor;
  final Color? hintTextColor; // Color for hint text
  final Color? borderColor; // Color for hint text
  final double? hintTextSize; // Font size for hint text
  final double? radius; // Font size for hint text
  final InputDecoration? decoration; // Font size for hint text
  final String? suffixText; // Text for suffix
  final TextStyle? suffixTextStyle; // Style for suffix text
  final String? Function(String?)? validator; // Nullable validator function

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.suffixIcon,
    this.readonly = false,
    this.prefixIconPath,
    this.maxLines = 1,
    this.onFieldSubmit,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.radius,
    this.decoration,
    this.borderColor = const Color(0xffE7EAF2),
    this.border = InputBorder.none,
    this.enabledBorder = InputBorder.none,
    this.focusedBorder = InputBorder.none,
    this.containerColor = Colors.white,
    this.hintTextColor = const Color(0xff9597A6), // Default color
    this.hintTextSize = 16, // Default font size
    this.suffixText, // Nullable suffix text
    this.suffixTextStyle, // Nullable suffix text style
    this.validator, // Nullable validator function
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(radius ?? 50.h),
        border:
        borderColor != null ? Border.all(color: borderColor!) : Border(),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readonly,
        obscureText: obscureText,
        obscuringCharacter: "*",
        maxLines: maxLines,
        onFieldSubmitted: onFieldSubmit,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.inter(
          fontSize: getWidth(14),
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        validator: validator, // Use the passed validator function here
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: decoration ?? InputDecoration(
          prefixIcon: prefixIconPath,
          suffixIcon: suffixIcon,
          suffixText: suffixText, // Dynamic suffixText
          suffixStyle:
          suffixTextStyle ??
              GoogleFonts.inter(
                fontSize: getWidth(14), // Default size for the suffix text
                fontWeight: FontWeight.w400,
                color:
                AppColors
                    .textSecondary, // Default color for the suffix text
              ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: getWidth(
              hintTextSize ?? 14,
            ), // Use dynamic size, default to 15
            fontWeight: FontWeight.w400,
            color: hintTextColor ?? AppColors.backgroundDark, // Use dynamic color, default to textSecondary
          ),
          fillColor: Colors.white,
          border: border,
          focusedBorder: focusedBorder,
          focusedErrorBorder: focusedBorder,
          enabledBorder: enabledBorder,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }
}
