// models/chat_model.dart

class ChatMessage {
  final String id; // Message unique ID
  final String senderId; // Sender user ID
  final String receiverId; // Receiver user ID
  final String message; // Text message
  final String? mediaUrl; // Optional media URL (image/video)
  final DateTime timestamp; // Message time
  final bool isRead; // Read status

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.mediaUrl,
    required this.timestamp,
    this.isRead = false,
  });

  // From JSON (API response)
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      mediaUrl: json['mediaUrl'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  // To JSON (Send to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'mediaUrl': mediaUrl,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
