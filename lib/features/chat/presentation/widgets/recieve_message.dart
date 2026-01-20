
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:gat/features/chat/presentation/widgets/view_image_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/common/widgets/custom_text.dart';

class ReceivedMessage extends StatelessWidget {
  final String? message;
  final String? time;
  final String? image;

  const ReceivedMessage({
    super.key,
    this.message,
    this.time,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          if (image?.isNotEmpty == true) ...[
            GestureDetector(
              onTap: () => Get.to(() => ViewImageScreen(imageUrl: image)),
              child: Image.network(
                image!,
                fit: BoxFit.fill,
                height: 124.h,
                width: 124.w,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 8),
          ],

          if (message?.isNotEmpty == true) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 8,
                    bottom: 8,
                  ),
                  constraints: BoxConstraints(maxWidth: 260.w),
                  decoration: const BoxDecoration(
                    color: Color(0xffFAFAFA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: CustomText(
                    text: message!,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff000000),
                  ),
                ),
                CustomText(
                  text: _formatTime(time),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  String _formatTime(String? rawTime) {
    if (rawTime == null) return '';
    try {
      final dateTime = DateTime.parse(rawTime).toLocal();
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return rawTime;
    }
  }
}