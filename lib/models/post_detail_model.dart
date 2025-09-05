// models/post_detail_model.dart

class PostDetailModel {
  final String postId;
  final String userId;
  final String username;
  final String userProfilePic;
  final String caption;
  final List<String> mediaUrls; // Images or videos
  final List<LikeModel> likes;
  final List<CommentModel> comments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int shareCount;
  final int viewCount;
  final bool isSaved;
  final bool isLikedByCurrentUser;

  PostDetailModel({
    required this.postId,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.caption,
    required this.mediaUrls,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
    this.shareCount = 0,
    this.viewCount = 0,
    this.isSaved = false,
    this.isLikedByCurrentUser = false,
  });

  // JSON serialization
  factory PostDetailModel.fromJson(Map<String, dynamic> json) {
    return PostDetailModel(
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      userProfilePic: json['userProfilePic'] ?? '',
      caption: json['caption'] ?? '',
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      likes: (json['likes'] as List<dynamic>? ?? [])
          .map((e) => LikeModel.fromJson(e))
          .toList(),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => CommentModel.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      shareCount: json['shareCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      isSaved: json['isSaved'] ?? false,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'userId': userId,
        'username': username,
        'userProfilePic': userProfilePic,
        'caption': caption,
        'mediaUrls': mediaUrls,
        'likes': likes.map((e) => e.toJson()).toList(),
        'comments': comments.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'shareCount': shareCount,
        'viewCount': viewCount,
        'isSaved': isSaved,
        'isLikedByCurrentUser': isLikedByCurrentUser,
      };
}

// Like model
class LikeModel {
  final String userId;
  final String username;

  LikeModel({required this.userId, required this.username});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
      };
}

// Comment model
class CommentModel {
  final String commentId;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'userId': userId,
        'username': username,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };
}
