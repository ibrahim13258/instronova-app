// models/message_model.dart

import 'package:flutter/foundation.dart';

class MessageModel {
  final String id; // Unique message ID
  final String senderId; // Message sender user ID
  final String receiverId; // Message receiver user ID
  final String message; // Message text content
  final DateTime timestamp; // Time when message sent
  final bool isRead; // Message read status
  final String? mediaUrl; // Optional media URL (image/video)
  final String? mediaType; // Optional media type (image/video/audio)

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.mediaUrl,
    this.mediaType,
  });

  // Convert JSON to MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
    );
  }

  // Convert MessageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
    };
  }

  // Copy with method for easy update
  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? mediaUrl,
    String? mediaType,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
    );
  }
}
