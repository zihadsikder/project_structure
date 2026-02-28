import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../core/utils/constants/app_sizer.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/chat_controller.dart';


class MessageInputBox extends StatelessWidget {
  final ChatController chatController;
  final String receiverId;

  const MessageInputBox({
    super.key,
    required this.chatController,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            // Camera button
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () {
                chatController.pickImage(fromCamera: true);
              },
            ),

            // Gallery button
            IconButton(
              icon: const Icon(Icons.image_outlined, color: Colors.white),
              onPressed: () {
                chatController.pickImage(fromCamera: false);
              },
            ),

            // Text field
            Expanded(
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: chatController.textController,
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none, // no border when enabled
                    focusedBorder: InputBorder.none, // no border when focused
                    disabledBorder: InputBorder.none, // no border when disabled
                    filled: false, // no background fill
                    isDense: true, // reduces vertical padding (optional)
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ), // remove extra padding (optional)
                  ),
                  onSubmitted: (_) {
                    if (receiverId.isNotEmpty &&
                        !chatController.isSending.value) {
                      chatController.sendMessage(
                        message: chatController.textController.text,
                        receiverId: receiverId,
                      );
                    }
                  },
                ),
              ),
            ),

            // Send button
            Obx(
                  () => chatController.isSending.value
                  ? Container(
                padding: const EdgeInsets.all(12),
                width: 48,
                height: 48,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (receiverId.isNotEmpty) {
                    chatController.sendMessage(
                      message: chatController.textController.text,
                      receiverId: receiverId,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}