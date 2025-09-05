// models/like_model.dart

class Like {
  final String id; // Unique like ID
  final String postId; // ID of the post that was liked
  final String userId; // ID of the user who liked
  final String username; // Username of the liker
  final String userAvatar; // URL of user's profile picture
  final DateTime likedAt; // Timestamp when liked

  Like({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.likedAt,
  });

  // Convert JSON to Like object
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      likedAt: DateTime.parse(json['likedAt']),
    );
  }

  // Convert Like object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userAvatar': userAvatar,
      'likedAt': likedAt.toIso8601String(),
    };
  }
}
