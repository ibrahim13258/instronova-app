// models/comment.dart

/// Represents a comment on a post
class Comment {
  /// Unique comment ID
  final String id;

  /// User ID of the commenter
  final String userId;

  /// Username of the commenter
  final String username;

  /// Profile picture URL of the commenter
  final String userImageUrl;

  /// Text content of the comment
  final String text;

  /// Timestamp of comment creation
  final DateTime createdAt;

  /// Number of likes on the comment
  final int likeCount;

  /// Whether the current user has liked this comment
  final bool isLikedByUser;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.text,
    required this.createdAt,
    this.likeCount = 0,
    this.isLikedByUser = false,
  });

  /// Deserialize from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userImageUrl: json['userImageUrl'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likeCount: json['likeCount'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'isLikedByUser': isLikedByUser,
    };
  }
}
