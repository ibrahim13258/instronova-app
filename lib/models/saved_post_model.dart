// models/saved_post_model.dart

class SavedPost {
  final String id; // Unique post ID
  final String userId; // User who posted
  final String username; // Username of the poster
  final String userAvatar; // URL of user's profile picture
  final String postImage; // URL of the post image/video
  final String postCaption; // Post caption
  final int likesCount; // Number of likes
  final int commentsCount; // Number of comments
  final DateTime createdAt; // When the post was created
  final bool isVideo; // Whether post is a video

  SavedPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.postImage,
    required this.postCaption,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.isVideo = false,
  });

  // Convert JSON to SavedPost object
  factory SavedPost.fromJson(Map<String, dynamic> json) {
    return SavedPost(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      userAvatar: json['userAvatar'],
      postImage: json['postImage'],
      postCaption: json['postCaption'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      createdAt: DateTime.parse(json['createdAt']),
      isVideo: json['isVideo'] ?? false,
    );
  }

  // Convert SavedPost object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userAvatar': userAvatar,
      'postImage': postImage,
      'postCaption': postCaption,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': createdAt.toIso8601String(),
      'isVideo': isVideo,
    };
  }
}
