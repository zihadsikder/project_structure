import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketClient {
  WebSocketChannel? _channel;
  Function(String)? onMessageReceived;
  late String _socketUrl;
  bool _isConnected = false;
  bool _isReconnecting = false;

  // Reconnect delay
  final Duration _reconnectDelay = const Duration(seconds: 5);

  // Initialize Socket
  void connect(String socketUrl) {
    _socketUrl = socketUrl;
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_socketUrl));
    _isConnected = true;

    _channel?.stream.listen(
          (message) {
        debugPrint("Received WebSocket Message: $message");
        onMessageReceived?.call(message);
      },
      onError: (error) {
        debugPrint("WebSocket error: $error");
        _isConnected = false;
        _reconnect();
      },
      onDone: () {
        log("WebSocket connection closed with code: ${_channel?.closeCode}, reason: ${_channel?.closeReason}");
        _isConnected = false;
        _reconnect();
      },
      cancelOnError: true,
    );

    debugPrint("WebSocket connected to $_socketUrl");
  }

  // Auto-Reconnect logic
  void _reconnect() async {
    if (_isConnected || _isReconnecting) return;

    _isReconnecting = true;
    debugPrint("Reconnecting in ${_reconnectDelay.inSeconds} seconds...");
    await Future.delayed(_reconnectDelay);

    if (!_isConnected) {
      debugPrint("Attempting to reconnect...");
      _connect();
    }
    _isReconnecting = false;
  }

  // Join room
  void joinRoom(String? user1Id, String user2Id) {
    final message = jsonEncode({
      "type": "joinRoom",
      "user1Id": user1Id,
      "user2Id": user2Id,
    });
    _sendMessage(message);
  }

  // // View messages in a chatroom
  // void viewMessage(String chatroomId, String userId) {
  //   final message = jsonEncode({
  //     "type": "viewMessages",
  //     "chatroomId": chatroomId,
  //     "userId": userId,
  //   });
  //   _sendMessage(message);
  // }
  /// Load more messages with lastMessageId
  void loadMoreMessages(String chatroomId, String userId, String lastMessageId) {
    final message = jsonEncode({
      "type": "loadMoreMessages",
      "chatroomId": chatroomId,
      "lastMessageId": lastMessageId,
    });
    _sendMessage(message);
  }

  // Send Message
  void sendMessage(Map<String, dynamic> message) {
    final encodedMessage = jsonEncode(message);
    _sendMessage(encodedMessage);
  }

  void _sendMessage(String message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(message);
      log("Message sent: $message");
    } else {
      debugPrint("WebSocket is not connected. Message not sent.");
    }
  }

  // Disconnect from socket
  void disconnect() {
    try {
      _channel?.sink.close(status.normalClosure);
      _isConnected = false;
      log("WebSocket connection closed manually.");
    } catch (e) {
      debugPrint("Error closing WebSocket: $e");
    }
  }

  // Callback function for incoming message
  void setOnMessageReceived(Function(String) callback) {
    onMessageReceived = callback;
  }
}