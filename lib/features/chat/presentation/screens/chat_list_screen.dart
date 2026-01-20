import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';


import '../../../../core/common/widgets/custom_search_field.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../controller/chat_controller.dart';
import '../../controller/chat_list_controller.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final ChatListController controller = Get.put(ChatListController());
  final ChatController chatController = Get.find<ChatController>(); // Use Get.find

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('chat'),),
      body: Column(
        children: [
          /// Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              hintText: 'Search chats',
              onChanged: controller.updateSearchQuery,
            ),
          ),

          /// Chat list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  itemCount: 6, // Consider making this dynamic
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          // Avatar shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Text shimmer
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 14,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 12,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              final chats = controller.filteredChatList;

              if (chats.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No chats found',
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshChatList,
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final user = chat.user;

                    return ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xFFFF9500),
                        backgroundImage: user?.image.isNotEmpty == true
                            ? NetworkImage(user!.image)
                            : null,
                        child: user?.image.isEmpty == true
                            ? CustomText(
                          text: user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : "?",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )
                            : null,
                      ),
                      title: CustomText(
                        text: user?.name ?? "Unknown User",
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      subtitle: CustomText(
                        text: chat.lastMessage ?? "No message yet",
                        color: Colors.grey[600],
                        fontSize: 13.sp,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey,
                        size: 16,
                      ),
                      onTap: () {
                        if (user?.id != null) {
                          chatController.createChatRoom(user2Id: user!.id);
                          Get.to(() => ChatScreen(
                            user2ndId: user.id,
                            userName: user.name,
                            profileImage: user.image,
                          ));
                        }
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}