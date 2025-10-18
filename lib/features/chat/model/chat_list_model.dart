import 'dart:convert';

GetChatListModel getChatListModelFromJson(String str) => GetChatListModel.fromJson(json.decode(str));

String getChatListModelToJson(GetChatListModel data) => json.encode(data.toJson());

class GetChatListModel {
  final bool success;
  final String message;
  final List<ChatData> data;

  GetChatListModel({
    this.success = false,
    this.message = '',
    this.data = const [],
  });

  factory GetChatListModel.fromJson(Map<String, dynamic> json) => GetChatListModel(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    data: json["data"] == null
        ? []
        : List<ChatData>.from(json["data"]!.map((x) => ChatData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ChatData {
  final String conversationId;
  final User? user;
  final String lastMessage;
  final DateTime? lastMessageDate;
  final int numberOfUnreadMessages;

  ChatData({
    this.conversationId = '',
    this.user,
    this.lastMessage = '',
    this.lastMessageDate,
    this.numberOfUnreadMessages = 0,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    conversationId: json["conversationId"] ?? '',
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    lastMessage: json["lastMessage"] ?? '',
    lastMessageDate: json["lastMessageDate"] == null ? null : DateTime.parse(json["lastMessageDate"]),
    numberOfUnreadMessages: json["numberOfUnreadMessages"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "conversationId": conversationId,
    "user": user?.toJson(),
    "lastMessage": lastMessage,
    "lastMessageDate": lastMessageDate?.toIso8601String(),
    "numberOfUnreadMessages": numberOfUnreadMessages,
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final String image;

  User({
    this.id = '',
    this.name = '',
    this.email = '',
    this.image = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    email: json["email"] ?? '',
    image: json["image"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "image": image,
  };
}