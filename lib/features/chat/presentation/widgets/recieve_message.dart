
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

  const ReceivedMessage({super.key, this.message, this.time, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 280.w),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image?.isNotEmpty == true)
                      GestureDetector(
                        onTap: () =>
                            Get.to(() => ViewImageScreen(imageUrl: image)),
                        child: CachedNetworkImage(
                          imageUrl: image!,
                          fit: BoxFit.cover,
                          height: 200.h,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            height: 200.h,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 100.h,
                            width: 100.w,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    if (message?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: CustomText(
                          text: message!,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: CustomText(
                text: _formatTime(time),
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
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