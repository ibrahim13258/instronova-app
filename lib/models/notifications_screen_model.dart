// models/notifications_screen_model.dart

class NotificationModel {
  final String id; // Unique notification id
  final String type; // like, comment, follow, mention, etc.
  final String content; // Notification text
  final String senderId; // User who triggered the notification
  final String senderName; // Name of the sender
  final String senderProfileUrl; // Profile image URL
  final String postId; // Related post id if any
  final bool isRead; // Notification read status
  final DateTime createdAt; // Timestamp

  NotificationModel({
    required this.id,
    required this.type,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderProfileUrl,
    this.postId = '',
    this.isRead = false,
    required this.createdAt,
  });

  // Factory method to create from JSON (API response)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderProfileUrl: json['senderProfileUrl'] ?? '',
      postId: json['postId'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfileUrl': senderProfileUrl,
      'postId': postId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
