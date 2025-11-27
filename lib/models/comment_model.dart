// models/comment_model.dart

// GetX removed for Provider consistency

class CommentModel {
  final String id;
  final String postId; // जिस post पर comment है
  final String userId; // comment करने वाला user
  final String username; // user का नाम
  final String userProfilePic; // user profile picture URL
  final String commentText; // comment content
  final DateTime timestamp; // comment का समय
  final RxInt likes; // comment पर likes
  final RxBool isLiked; // current user ने like किया है या नहीं

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.commentText,
    required this.timestamp,
    int likes = 0,
    bool isLiked = false,
  })  : likes = likes.obs,
        isLiked = isLiked.obs;

  // Like toggle function
  void toggleLike() {
    if (isLiked.value) {
      likes.value -= 1;
      isLiked.value = false;
    } else {
      likes.value += 1;
      isLiked.value = true;
    }
  }

  // JSON से convert करने वाला function
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      username: json['username'],
      userProfilePic: json['userProfilePic'],
      commentText: json['commentText'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  // JSON में convert करने वाला function
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userProfilePic': userProfilePic,
      'commentText': commentText,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes.value,
      'isLiked': isLiked.value,
    };
  }
}
