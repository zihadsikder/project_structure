import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../../../core/services/Auth_service.dart';

import '../../profile/controller/profile_controller.dart';
import 'web_socket_client.dart';

class ChatController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final WebSocketClient socketClient = WebSocketClient();
  late final ProfileController profileController;
  final ScrollController scrollController = ScrollController();
  final Box _chatBox = Hive.box('chatMessages');

  // Observables
  var messages = <Map<String, dynamic>>[].obs;
  RxBool showAttachIcon = true.obs;
  RxString selectedImage = "".obs;
  RxString roomId = "".obs;
  RxString generatedImageLink = "".obs;
  RxBool isConnected = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;
  RxString lastMessageId = "".obs;
  static const int _pageSize = 20; // Load 20 messages per page

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();
    _initSocketConnection();
    _setupScrollListener();
  }

  void _initSocketConnection() {
    socketClient.connect(AppUrls.connectSocket);
    isConnected.value = true;

    socketClient.setOnMessageReceived((message) {
      log("📩 WebSocket Received: $message");
      _handleIncomingMessage(message);
    });
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels <= scrollController.position.minScrollExtent + 50 &&
          !isLoadingMore.value &&
          hasMore.value) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> createChatRoom({required String user2Id}) async {
    final userId = profileController.profileDataModel.value.data?.id ?? '';
    if (userId.isEmpty || user2Id.isEmpty) {
      log("⚠️ User ID or user2Id not found, cannot join room.");
      return;
    }
    log("📤 Sending joinRoom: user1Id=$userId, user2Id=$user2Id");
    socketClient.joinRoom(userId, user2Id);
    _loadCachedMessages();
  }

  void _loadCachedMessages() {
    if (_chatBox.containsKey(roomId.value) && messages.isEmpty) {
      final cachedMessages = List<Map<String, dynamic>>.from(_chatBox.get(roomId.value));
      messages.value = cachedMessages.reversed.toList(); // Load in reverse order for bottom-newest
      if (messages.isNotEmpty) {
        lastMessageId.value = messages.first['id']; // Use first ID for pagination (oldest)
      }
    }
  }

  void _saveMessagesToCache() {
    if (roomId.value.isNotEmpty) {
      _chatBox.put(roomId.value, messages.reversed.toList()); // Save in reverse order
    }
  }

  void _loadMoreMessages() async {
    if (lastMessageId.value.isEmpty || !hasMore.value) return;
    isLoadingMore.value = true;
    final userId = profileController.profileDataModel.value.data?.id ?? '';
    log("📤 Loading more messages with lastMessageId: $lastMessageId");
    socketClient.loadMoreMessages(roomId.value, userId, lastMessageId.value);
  }

  Future<void> sendMessage({
    required String message,
    required String receiverId,
    String? image,
  }) async {
    if (message.isEmpty && (image == null || image.isEmpty) && selectedImage.value.isEmpty) return;

    try {
      String? imageUrl = image;
      if (selectedImage.value.isNotEmpty && (image == null || image.isEmpty)) {
        bool uploadSuccess = await generateImageLink();
        if (uploadSuccess && generatedImageLink.value.isNotEmpty) {
          imageUrl = generatedImageLink.value;
        } else {
          log("❌ Failed to upload image, sending message without image");
        }
      }

      if (roomId.value.isEmpty) {
        log("⚠️ chatroomId is empty, cannot send message.");
        return;
      }

      final Map<String, dynamic> messageBody = {
        "type": "sendMessage",
        "chatroomId": roomId.value,
        "senderId": profileController.profileDataModel.value.data?.id ?? '',
        "receiverId": receiverId,
        "content": message,
        "file": imageUrl ?? "",
      };

      log("📤 Sending message: $messageBody");
      socketClient.sendMessage(messageBody);

      textController.clear();
      selectedImage.value = "";
      generatedImageLink.value = "";
      showAttachIcon.value = true;
    } catch (e) {
      log("❌ Send Message Error: $e");
    }
  }

  Future<void> pickImage({required bool fromCamera}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      selectedImage.value = image.path;
      log("🖼️ Selected image: ${image.path}");
    }
  }

  Future<bool> generateImageLink() async {
    if (selectedImage.value.isEmpty) return false;

    final dio.Dio dioClient = dio.Dio();
    dioClient.options = dio.BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    );

    try {
      final imageFile = await dio.MultipartFile.fromFile(
        selectedImage.value,
        filename: selectedImage.value.split('/').last,
      );

      final formData = dio.FormData.fromMap({"chatImage": imageFile});
      final response = await dioClient.post(
        AppUrls.generateImageLink,
        data: formData,
        options: dio.Options(headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${AuthService.token}',
        }),
      );

      log("📤 Upload Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final imageLink = responseData["data"]?["file"] ??
              responseData["file"] ??
              responseData["url"] ??
              responseData["chatImage"];
          if (imageLink != null && imageLink.isNotEmpty) {
            generatedImageLink.value = imageLink;
            log("✅ Image uploaded successfully: $imageLink");
            return true;
          }
        }
      }
      log("❌ Image upload failed: ${response.data?["message"] ?? 'No message'}");
      return false;
    } catch (e) {
      log("❌ Image upload failed: $e");
      return false;
    }
  }

  void _handleIncomingMessage(String rawMessage) {
    try {
      final decodedMessage = jsonDecode(rawMessage);
      if (decodedMessage is! Map<String, dynamic>) {
        log("❌ Invalid message format: Not a JSON object");
        return;
      }

      log("📥 Handling message type: ${decodedMessage['type']}");

      switch (decodedMessage['type']) {
        case 'loadMessages':
          final conversation = decodedMessage['conversation'] ?? decodedMessage;
          log("📥 Raw conversation: $conversation");
          if (conversation != null) {
            roomId.value = conversation['id'] ??
                (conversation['messages']?.isNotEmpty == true
                    ? conversation['messages'][0]['conversationId']
                    : roomId.value);
            log("📥 Set roomId: ${roomId.value}");
            hasMore.value = decodedMessage['hasMore'] ?? false;
            messages.clear();
            final allMessages = (conversation['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
            messages.value = allMessages.reversed.toList(); // Reverse for bottom-newest display
            if (messages.isNotEmpty) {
              lastMessageId.value = messages.first['id']; // Oldest message ID for next load
            }
            _saveMessagesToCache();
            _scrollToBottom();
          } else {
            log("⚠️ No conversation data in loadMessages response");
          }
          break;

        case 'loadMoreMessagesResponse':
          isLoadingMore.value = false;
          hasMore.value = decodedMessage['hasMore'] ?? false;
          final newMessages = (decodedMessage['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          if (newMessages.isNotEmpty) {
            messages.insertAll(0, newMessages.reversed.toList()); // Add older messages at the top
            lastMessageId.value = newMessages.first['id']; // Update with oldest message ID
            _saveMessagesToCache();
          }
          break;

        case 'receiveMessage':
        case 'messageSent':
          final message = decodedMessage['message'];
          if (message != null && message is Map<String, dynamic>) {
            final messageId = message['id'];
            if (messageId != null && !messages.any((msg) => msg['id'] == messageId)) {
              messages.add(message); // Add new message to the end
              _saveMessagesToCache();
              log("📥 Added new message with id: $messageId");
              _scrollToBottom();
            } else {
              log("⚠️ Duplicate or null message id detected, skipping: $messageId");
            }
          }
          break;

        default:
          log("⚠️ Unknown message type: ${decodedMessage['type']}");
      }
    } catch (e) {
      log("❌ Failed to handle message: $e");
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _addMessage(
      String messageId,
      String content,
      String senderId,
      String conversationId,
      bool isRead,
      String updatedAt,
      String fileUrl,
      ) {
    if (!messages.any((msg) => msg['id'] == messageId)) {
      messages.add({
        'id': messageId,
        'content': content,
        'senderId': senderId,
        'conversationId': conversationId,
        'isRead': isRead,
        'updatedAt': updatedAt,
        'file': fileUrl,
      });
      debugPrint("💬 Added message: $content (${fileUrl.isNotEmpty ? '📎 with file' : ''})");
    }
  }

  @override
  void onClose() {
    socketClient.disconnect();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}