import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? prefixIcon;
  final Widget? nextIcon;
  final Widget? child; // Added child parameter
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? color; // Added color parameter (button color)
  final Color? textColor; // Added textColor parameter (text color)

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.prefixIcon,
    this.nextIcon,
    this.child, // Child widget is passed as an optional parameter
    this.padding,
    this.borderRadius,
    this.color, // Optional color parameter
    this.textColor, // Optional text color parameter
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.primary, // Use the provided color or the default color
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.5),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: padding ?? EdgeInsets.symmetric(vertical: getHeight(17)),
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                const SizedBox(),
                SizedBox(
                  height: getHeight(22),
                  width: getWidth(22),
                  child: prefixIcon!,
                ),
              ],
              SizedBox(width: getWidth(8)),
              // Display text if no child is passed
              if (child == null) ...[
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: getWidth(16),
                    fontWeight: FontWeight.w600,
                    color: textColor ?? AppColors.textWhite, // Use the provided text color or the default color
                  ),
                ),
              ],
              // Display child if passed
              if (child != null) ...[
                child!,
              ],
              if (nextIcon != null) ...[
                SizedBox(
                  width: getWidth(25),
                  child: nextIcon!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
