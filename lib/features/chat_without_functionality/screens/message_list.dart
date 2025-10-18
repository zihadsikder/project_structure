import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/message_controller.dart';
import '../widgets/story_avatar.dart';

class MessageScreenWF extends StatelessWidget {
  const MessageScreenWF({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Story Section
            SizedBox(
              height: 100,
              child: Obx(
                    () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.stories.length,
                  itemBuilder: (context, index) {
                    final story = controller.stories[index];
                    return StoryAvatar(
                      storyImage: story.avatar,
                      name: story.name,
                    );
                  },
                ),
              ),
            ),

            // Recent Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Message List
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return MessageTile(message: message);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Navigate to chat page (replace with your actual chat screen)
        // Example:
        // Get.to(() => ChatWithoutFunc(userId: message.id));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(message.avatar),
        radius: 25,
      ),
      title: Text(
        message.userName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.timestamp,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          if (message.unread)
            const SizedBox(
              width: 8,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
