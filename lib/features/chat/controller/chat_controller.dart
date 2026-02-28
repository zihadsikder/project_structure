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
  RxString activePeerId = "".obs;
  late final Box _chatBox;
  // Observables
  var messages = <Map<String, dynamic>>[].obs;
  RxBool showAttachIcon = true.obs;
  RxString selectedImage = "".obs;
  RxString roomId = "".obs;
  RxString generatedImageLink = "".obs;
  RxBool isConnected = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoadingInitial = false.obs;
  RxBool hasMore = true.obs;
  RxString lastMessageId = "".obs;
  RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();
    _chatBox = Hive.box('chatMessages');
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
      // In a reversed list (reverse: true), maxScrollExtent is the top of the chat
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value &&
          hasMore.value) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> createChatRoom({required String user2Id}) async {
    final userId =
        profileController.profileDataModel.value.data?.id?.toString() ?? '';

    log(
      "🧩 createChatRoom() -> me=$userId, peer=$user2Id, prevRoom=${roomId.value}, prevPeer=${activePeerId.value}",
    );

    if (userId.isEmpty || user2Id.isEmpty) {
      log("⚠️ Missing IDs. me=$userId peer=$user2Id");
      isLoadingInitial.value = false;
      return;
    }

    // if already chatting with same peer, don't rejoin
    if (activePeerId.value == user2Id && roomId.value.isNotEmpty) {
      log("ℹ️ Same peer already active. Skip joinRoom.");
      return;
    }

    isLoadingInitial.value = true;

    // reset state
    messages.clear();
    roomId.value = "";
    lastMessageId.value = "";
    hasMore.value = true;

    activePeerId.value = user2Id;

    log("📤 joinRoom -> me=$userId peer=$user2Id");
    socketClient.joinRoom(userId, user2Id);

    // Load cache only AFTER roomId known (otherwise cache key empty)
    // So remove _loadCachedMessages() here
  }

  void _loadCachedMessages() {
    if (_chatBox.containsKey(roomId.value) && messages.isEmpty) {
      final cachedMessages = List<Map<String, dynamic>>.from(
        _chatBox.get(roomId.value),
      );
      messages.value = cachedMessages; // Store newest first
      if (messages.isNotEmpty) {
        lastMessageId.value =
        messages.last['id']; // Oldest message ID for next load
      }
    }
  }

  void _saveMessagesToCache() {
    if (cacheRoomId.isNotEmpty) {
      _chatBox.put(cacheRoomId, messages.toList()); // Save as newest first
    }
  }

  String get cacheRoomId => roomId.value;

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
  }) async {
    if ((message.trim().isEmpty && selectedImage.value.isEmpty) ||
        isSending.value) {
      return;
    }

    try {
      isSending.value = true;
      String? imageUrl;
      if (selectedImage.value.isNotEmpty) {
        bool uploadSuccess = await generateImageLink();

        if (uploadSuccess && generatedImageLink.value.isNotEmpty) {
          imageUrl = generatedImageLink.value;
        } else {
          log(
            "❌ Failed to upload image, continuing with text only or aborting if no text",
          );
          if (message.trim().isEmpty) {
            isSending.value = false;
            return;
          }
        }
      }

      if (roomId.value.isEmpty) {
        log("⚠️ chatroomId is empty, cannot send message.");
        isSending.value = false;
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
    } catch (e) {
      log("❌ Send Message Error: $e");
    } finally {
      isSending.value = false;
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
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${AuthService.token}',
          },
        ),
      );

      log("📤 Upload Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final imageLink =
              responseData["data"]?["file"] ??
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
      log(
        "❌ Image upload failed: ${response.data?["message"] ?? 'No message'}",
      );
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
          try {
            // server: {"type":"loadMessages","conversationId":"...","messages":[...],"hasMore":false}
            final convId = decodedMessage['conversationId']?.toString() ?? '';
            final msgList = (decodedMessage['messages'] as List? ?? [])
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();

            final incomingHasMore = decodedMessage['hasMore'] == true;

            log(
              "✅ loadMessages -> conversationId=$convId, messages=${msgList.length}, hasMore=$incomingHasMore",
            );

            if (convId.isNotEmpty) {
              roomId.value = convId;
            }

            messages.clear();
            // server seems sending newest-first already; if not sure, sort by createdAt
            messages.addAll(msgList);

            hasMore.value = incomingHasMore;

            if (messages.isNotEmpty) {
              lastMessageId.value = messages.last['id']?.toString() ?? '';
            } else {
              lastMessageId.value = '';
            }

            _saveMessagesToCache();
          } catch (e) {
            log("❌ loadMessages parse error: $e");
          } finally {
            isLoadingInitial.value = false;
          }
          break;

        case 'loadMoreMessagesResponse':
          isLoadingMore.value = false;
          hasMore.value = decodedMessage['hasMore'] ?? false;
          final newMessages =
              (decodedMessage['messages'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
                  [];
          if (newMessages.isNotEmpty) {
            messages.addAll(
              newMessages,
            ); // Append older messages at the end of newest-first list
            lastMessageId.value =
            messages.last['id']; // Update with oldest message ID
            _saveMessagesToCache();
          }
          break;

        case 'receiveMessage':
        case 'messageSent':
          final message = decodedMessage['message'];
          if (message != null && message is Map<String, dynamic>) {
            final conversationId = message['conversationId'];
            if (conversationId != null && roomId.value != conversationId) {
              roomId.value = conversationId;
              log("📥 Updated roomId from message: ${roomId.value}");
            }

            final messageId = message['id'];
            if (messageId != null &&
                !messages.any((msg) => msg['id'] == messageId)) {
              messages.insert(
                0,
                message,
              ); // Add new message to the beginning (newest first)
              _saveMessagesToCache();
              log("📥 Added new message with id: $messageId");
              // Scroll to bottom is not needed for reversed list usually,
              // but we might want to jump to 0 if user is far up
            } else {
              log(
                "⚠️ Duplicate or null message id detected, skipping: $messageId",
              );
            }
          }
          break;

        default:
          log("⚠️ Unknown message type: ${decodedMessage['type']}");
      }
    } catch (e) {
      log("❌ Failed to handle message: $e");
      isLoadingInitial.value = false;
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