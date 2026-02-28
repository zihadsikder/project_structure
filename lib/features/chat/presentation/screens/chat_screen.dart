import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizer.dart';

import '../../../profile/controller/profile_controller.dart';
import '../../controller/chat_controller.dart';

import '../widgets/message_input_box.dart';
import '../widgets/message_sent_by_me.dart';
import '../widgets/recieve_message.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    this.user2ndId,
    this.userName,
    this.profileImage,

  });

  final String? user2ndId;
  final String? userName;
  final String? profileImage;


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final ProfileController profileController = Get.find<ProfileController>();


  @override
  void initState() {
    super.initState();
    if (widget.user2ndId != null) {
      chatController.createChatRoom(user2Id: widget.user2ndId!);
      // Future.delayed(Duration.zero, () {
      //   chatController.loadInitialMessages(); // Load initial messages
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = profileController.profileDataModel.value.data?.id ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.profileImage?.isNotEmpty == true
                  ? NetworkImage(widget.profileImage!)
                  : null,
              backgroundColor: Colors.white,
              child: widget.profileImage?.isEmpty != false
                  ? CustomText(
                text: widget.userName?.isNotEmpty == true
                    ? widget.userName![0].toUpperCase()
                    : "?",
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              )
                  : null,
            ),
            const Gap(8),
            CustomText(
              text: widget.userName ?? 'Unknown User',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Messages section
            Expanded(
              child: Obx(() {
                if (chatController.isLoadingInitial.value &&
                    chatController.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (chatController.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 64.sp,
                          color: AppColors.textBlack.withOpacity(0.5),
                        ),
                        const Gap(16),
                        CustomText(
                          text:
                          "No messages yet.\nSay hi to start the conversation!",
                          textAlign: TextAlign.center,
                          color: AppColors.textSecondary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: chatController.scrollController,
                  reverse: true, // Latest message at the bottom (index 0)
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  itemCount:
                  chatController.messages.length +
                      (chatController.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (chatController.isLoadingMore.value &&
                        index == chatController.messages.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final message = chatController.messages[index];
                    return message["senderId"] == userId
                        ? MessageSentByMe(
                      message: message['content'] ?? '',
                      time: message['updatedAt'] ?? '',
                      image: message["file"]?.isNotEmpty == true
                          ? message["file"]
                          : null,
                    )
                        : ReceivedMessage(
                      message: message['content'] ?? '',
                      time: message['updatedAt'] ?? '',
                      image: message["file"]?.isNotEmpty == true
                          ? message["file"]
                          : null,
                    );
                  },
                );
              }),
            ),

            /// Selected image preview
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(
                    () => chatController.selectedImage.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 120.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: DecorationImage(
                            image: FileImage(
                              File(chatController.selectedImage.value),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: GestureDetector(
                          onTap: () {
                            chatController.selectedImage.value = "";
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),

            /// Bottom input field
            MessageInputBox(
              chatController: chatController,
              receiverId: widget.user2ndId ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
