import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';

import '../../../../core/common/widgets/custom_text.dart';



class ProfileItemCard extends StatelessWidget {
  final void Function()? onTap;
  final String? icon;
  final String text;

  const ProfileItemCard({
    super.key,
    this.onTap,
this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44.h,
        width: double.infinity,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(icon!, height: 20.h, width: 20.w),
            SizedBox(width: 8),
            CustomText(
              text: text,
              color: Color(0xFF6C757D),
              fontSize: 14.sp,
            ),
            Spacer(),
            //Image.asset(IconPath.arrowForward, height: 12.h, width: 6.w),
            Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}
