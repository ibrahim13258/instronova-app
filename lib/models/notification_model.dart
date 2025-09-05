// models/notification_model.dart

class NotificationModel {
  final String id; // Unique notification ID
  final String type; // 'like', 'comment', 'follow', 'mention', etc.
  final String senderId; // User who triggered the notification
  final String senderName; // Sender's display name
  final String senderProfilePic; // URL of sender's profile picture
  final String postId; // Related post ID (if any)
  final String message; // Notification text
  final DateTime timestamp; // When the notification happened
  bool isRead; // Whether the notification is read or not

  NotificationModel({
    required this.id,
    required this.type,
    required this.senderId,
    required this.senderName,
    required this.senderProfilePic,
    this.postId = '',
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  // Factory method to create from JSON (for API)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderProfilePic: json['senderProfilePic'] ?? '',
      postId: json['postId'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
    );
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfilePic': senderProfilePic,
      'postId': postId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
