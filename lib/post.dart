// models/post.dart
import 'user.dart';
import 'comment.dart';

enum PostType { post, reel, story }
enum PostVisibility { public, private, friendsOnly }

class Media {
  final String url;
  final String? type; // image/video
  final String? thumbnailUrl; // for video

  Media({
    required this.url,
    this.type,
    this.thumbnailUrl,
  });
}

class Post {
  final String id;
  final User user; // reference to User model
  final List<Media> media; // multiple images/videos
  final String caption;
  final DateTime timestamp;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final PostType postType;
  final PostVisibility visibility;
  final List<String> taggedUserIds; // IDs of tagged users
  final String? location; // geotag
  final List<String>? hashtags; // extracted hashtags
  final int? viewCount; // for reels/stories
  final DateTime? expiryTime; // for story
  final List<Comment>? comments; // nested comment objects
  final String? musicName; // for reels
  final String? musicArtist; // for reels
  final Duration? reelDuration; // for reels

  Post({
    required this.id,
    required this.user,
    required this.media,
    required this.caption,
    required this.timestamp,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.postType = PostType.post,
    this.visibility = PostVisibility.public,
    this.taggedUserIds = const [],
    this.location,
    this.hashtags,
    this.viewCount,
    this.expiryTime,
    this.comments,
    this.musicName,
    this.musicArtist,
    this.reelDuration,
  });
}
