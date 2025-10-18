import 'package:get/get.dart';

class MessageController extends GetxController {
  final stories = <Story>[].obs;
  final messages = <Message>[].obs;
  final currentChat = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStories();
    loadMessages();
  }

  void loadStories() {
    stories.value = [
      Story(
        id: '1',
        name: 'Barry',
        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWIGudYgQRCo4zxHg3yIThPp3Uy9lw6-sj5g&s',
      ),
      Story(
        id: '2',
        name: 'Perez',
        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFPn2YdseHUgINzAiBus0D-iJmWxgtvzmsKw&s',
      ),
      Story(
        id: '3',
        name: 'Alvin',
        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi0ifMbGHdiCmoJ-UMygLyDqb6WeF5MJunmA&s',
      ),
      Story(
        id: '4',
        name: 'Dan',
        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxwjQnGqcd40acbM_VU7CfvP1rAcN4bmn6cg&s',
      ),
    ];
  }

  void loadMessages() {
    messages.value = [
      Message(
        id: '1',
        userName: 'Jon Jones',
        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGPKzVM-1tHxYsd5dga0_AlHFc1813DzxFew&s',
        lastMessage: 'Haha, yes I\'ve seen your pr...',
        timestamp: '09:41',
        unread: false,
      ),
      Message(
        id: '2',
        userName: 'Charlotte Liddell',
        avatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS41_T5RNaT5MLPvBQgsw0rfCxzxaJRzdztOw&s',
        lastMessage: 'Haha, yes I\'ve seen your pr...',
        timestamp: '09:41',
        unread: true,
      ),
      // Add more messages...
    ];
  }

  void loadChat(String userId) {
    currentChat.value = [
      ChatMessage(
        id: '1',
        message: 'Hi, good morning Jon Jones... 😊',
        isMe: true,
        timestamp: '09:41',
        senderAvatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS41_T5RNaT5MLPvBQgsw0rfCxzxaJRzdztOw&s',
      ),
      ChatMessage(
        id: '2',
        message: 'It seems we have a lot in common & have a lot of interest in each other 😂',
        isMe: true,
        timestamp: '09:41',
        senderAvatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS41_T5RNaT5MLPvBQgsw0rfCxzxaJRzdztOw&s',
      ),
      ChatMessage(
        id: '3',
        message: 'Hello, good morning too Andrew ☀️',
        isMe: false,
        timestamp: '09:42',
        senderAvatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS41_T5RNaT5MLPvBQgsw0rfCxzxaJRzdztOw&s',
      ),
      ChatMessage(
        id: '4',
        message: 'Haha, yes I\'ve seen your profile and I\'m a perfect match 🥰🥰',
        isMe: false,
        timestamp: '09:42',
        senderAvatar: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS41_T5RNaT5MLPvBQgsw0rfCxzxaJRzdztOw&s',
      ),
    ];
  }
}

class Story {
  final String id;
  final String name;
  final String avatar;

  Story({
    required this.id,
    required this.name,
    required this.avatar,
  });
}

class Message {
  final String id;
  final String userName;
  final String avatar;
  final String lastMessage;
  final String timestamp;
  final bool unread;

  Message({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.lastMessage,
    required this.timestamp,
    required this.unread,
  });
}

class ChatMessage {
  final String id;
  final String message;
  final bool isMe;
  final String senderAvatar;
  final String timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.senderAvatar,
  });
}