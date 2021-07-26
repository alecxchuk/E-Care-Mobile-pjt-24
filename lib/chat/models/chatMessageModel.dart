import 'package:e_care_mobile/chat/api/utils.dart';
import 'package:flutter/cupertino.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class ChatMessage {
  String messageContent;
  String messageType;
  final String userId;
  final DateTime createdAt;
  final String urlAvatar;
  final String name;
  final String deleted;
  final bool isMessageRead;

  ChatMessage({
    @required this.messageContent,
    @required this.messageType,
    @required this.userId,
    @required this.createdAt,
    @required this.urlAvatar,
    @required this.name,
    @required this.deleted,
    @required this.isMessageRead,
  });

  static ChatMessage fromJson(Map<String, dynamic> json) =>
      ChatMessage(
        messageContent: json['messageContent'],
        messageType: json['messageType'],
        userId: json['userId'],
        createdAt: Utils.toDateTime(json['createdAt']),
        urlAvatar: json['urlAvatar'],
        name: json['name'],
        deleted: json['deleted'],
        isMessageRead: json['isMessageRead'],
      );

  Map<String, dynamic> toJson() =>
      {
        'messageContent': messageContent,
        'messageType': messageType,
        'userId': userId,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
        'urlAvatar': urlAvatar,
        'name': name,
        'deleted': deleted,
      };
}
