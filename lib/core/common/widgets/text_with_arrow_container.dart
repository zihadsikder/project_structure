import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_sizes.dart';
import 'custom_text.dart';

class TextWithArrow extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final TextOverflow? textOverflow;
  final Color? color;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;

  const TextWithArrow({
    super.key,
    this.text,
    this.fontSize,
    this.textOverflow,
    this.color,
    this.fontWeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: getWidth(10), vertical: getHeight(14)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // CustomText Widget
            Flexible(
              child: CustomText(
                text: text ?? '',
                fontSize: fontSize ?? getWidth(14),
                textOverflow: TextOverflow.ellipsis,
                color: AppColors.textPrimary,
                fontWeight: fontWeight ?? FontWeight.w500
              ),
            ),
            SizedBox(width: getWidth(8)),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: getWidth(16),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
