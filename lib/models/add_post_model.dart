// models/add_post_model.dart

class AddPostModel {
  String? postId;
  String userId;
  String? imageUrl; // Single image post
  String? videoUrl; // Reel or video post
  String caption;
  List<String>? tags; // Tagged users
  DateTime createdAt;
  int likesCount;
  int commentsCount;
  bool isPrivate;

  AddPostModel({
    this.postId,
    required this.userId,
    this.imageUrl,
    this.videoUrl,
    this.caption = '',
    this.tags,
    DateTime? createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isPrivate = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // JSON serialization for API or local storage
  factory AddPostModel.fromJson(Map<String, dynamic> json) {
    return AddPostModel(
      postId: json['postId'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      caption: json['caption'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isPrivate: json['isPrivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'caption': caption,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isPrivate': isPrivate,
    };
  }
}
