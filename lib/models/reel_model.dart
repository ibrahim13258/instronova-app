// models/reel_model.dart

class ReelModel {
  final String id; // Unique reel ID
  final String userId; // Reel creator's user ID
  final String username; // Creator username
  final String userProfilePic; // Creator profile image
  final String videoUrl; // Reel video URL
  final String caption; // Reel caption
  final List<String> likes; // List of user IDs who liked
  final List<String> comments; // List of comment IDs
  final int views; // Reel view count
  final DateTime createdAt; // Reel creation timestamp
  final bool isLikedByCurrentUser; // If current user liked this reel

  ReelModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.videoUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.views,
    required this.createdAt,
    this.isLikedByCurrentUser = false,
  });

  // Factory method to create ReelModel from JSON
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userProfilePic: json['userProfilePic'] as String,
      videoUrl: json['videoUrl'] as String,
      caption: json['caption'] as String,
      likes: List<String>.from(json['likes'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
      views: json['views'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool? ?? false,
    );
  }

  // Convert ReelModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfilePic': userProfilePic,
      'videoUrl': videoUrl,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'views': views,
      'createdAt': createdAt.toIso8601String(),
      'isLikedByCurrentUser': isLikedByCurrentUser,
    };
  }
}
