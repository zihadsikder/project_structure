

import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/app_colors.dart';

import '../controller/message_controller.dart';

class ChatWithoutFunc extends StatelessWidget {
  final String userId;

  const ChatWithoutFunc({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController());
    controller.loadChat(userId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                controller.messages.firstWhere((m) => m.id == userId).avatar,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              controller.messages.firstWhere((m) => m.id == userId).userName,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.currentChat.length,
                itemBuilder: (context, index) {
                  final message = controller.currentChat[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 4.w),
            margin: EdgeInsets.only(
                left: 16.w, right: 16.w, bottom: 32.h, top: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.h),
              color: const Color(0xffF8FAFB),
              border: Border.all(
                color: AppColors.textFormFieldBorder,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        height: 25 / 19,
                        //letterSpacing: -0.6,

                      ),
                      border: InputBorder.none,
                      // Remove the default border
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none, // No border when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none, // No border when focused
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: const BoxDecoration(
                        color: AppColors.primary,
                        //borderRadius: BorderRadius.circular(4.h),
                        shape: BoxShape.circle),
                    child:Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//
// class ChatBubble extends StatelessWidget {
//   final ChatMessage message;
//
//   const ChatBubble({
//     super.key,
//     required this.message,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: message.isMe ? Colors.grey.shade200 : Colors.grey.shade200,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24.h),
//             topRight: Radius.circular(24.h),
//             bottomLeft: Radius.circular(message.isMe ? 24.h : 0),
//             bottomRight: Radius.circular(message.isMe ? 0 : 24.h),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(message.message),
//             const SizedBox(height: 4),
//             Text(
//               message.timestamp,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isMe) ...[
              CircleAvatar(
                radius: 16.h,
                backgroundImage: NetworkImage(message.senderAvatar), // Add senderAvatar to ChatMessage model
              ),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.h),
                    topRight: Radius.circular(24.h),
                    bottomLeft: Radius.circular(message.isMe ? 24.h : 0),
                    bottomRight: Radius.circular(message.isMe ? 0 : 24.h),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message.timestamp,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}