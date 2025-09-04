/// Comment model for Post/Reel/Story
class Comment {
  final String id;
  final String userId;
  final String username;
  final String userImageUrl;
  final String text;
  final DateTime createdAt;
  final int likeCount;
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
