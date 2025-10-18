import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import '../../../../core/localization/app_texts.dart';

import '../../../profile/controller/profile_controller.dart';
import '../../controller/chat_controller.dart';
import '../../controller/chat_list_controller.dart';
import '../widgets/message_input_box.dart';
import '../widgets/message_sent_by_me.dart';
import '../widgets/recieve_message.dart';

import '../../../../routes/app_routes.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    this.user2ndId,
    this.userName,
    this.profileImage,
    this.role,
  });

  final String? user2ndId;
  final String? userName;
  final String? profileImage;
  final String? role;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final ProfileController profileController = Get.put(ProfileController());
  final ChatListController chatListController = Get.put(ChatListController());


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
        title: InkWell(
          onTap: () {
            //Get.toNamed(
              //AppRoute.seekerProfileScreen,
             // arguments: {'formScreen': 'chat', 'id': widget.user2ndId},
            //);
          },
          child: Row(
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

      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Messages section
            Expanded(
              child: Obx(() {
                if (chatController.messages.isEmpty && !chatController.isLoadingMore.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: chatController.scrollController,
                  reverse: false, // Latest message at the bottom
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemCount: chatController.messages.length +
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
                    final message = chatController.messages[index]; // Use natural order
                    return message["senderId"] == userId
                        ? MessageSentByMe(
                      message: message['content'] ?? '',
                      time: message['updatedAt'] ?? '',
                      image: message["file"]?.isNotEmpty == true ? message["file"] : null,
                    )
                        : ReceivedMessage(
                      message: message['content'] ?? '',
                      time: message['updatedAt'] ?? '',
                      image: message["file"]?.isNotEmpty == true ? message["file"] : null,
                    );
                  },
                );
              }),
            ),

            /// Selected image preview
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => chatController.selectedImage.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 10),
                child: Stack(
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(chatController.selectedImage.value)),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      top: 2,
                      child: GestureDetector(
                        onTap: () {
                          chatController.selectedImage.value = "";
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink()),
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