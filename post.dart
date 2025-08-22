// models/post.dart
class Post {
  final String id;
  final String userId;
  final String username;
  final String userImageUrl;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final bool isPost;
  final bool isReel;
  final bool isStory;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.isPost = true,
    this.isReel = false,
    this.isStory = false,
  });
}
