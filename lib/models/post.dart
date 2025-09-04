import 'comment.dart';

/// Represents a single Post/Reel/Story in an Instagram-level system
class Post {
  /// Unique post ID
  final String id;

  /// ID of the user who created the post
  final String userId;

  /// Username of the post creator
  final String username;

  /// Profile picture URL of the creator
  final String userImageUrl;

  /// Main image or video URL of the post
  final String imageUrl;

  /// Caption text of the post
  final String caption;

  /// Timestamp of post creation
  final DateTime createdAt;

  /// Number of likes on the post
  final int likeCount;

  /// Number of comments on the post
  final int commentCount;

  /// Number of times the post has been shared
  final int shareCount;

  /// Whether the current user has liked this post
  final bool isLikedByUser;

  /// Whether the current user has saved this post
  final bool isSavedByUser;

  /// List of user IDs who liked this post
  final List<String> likedUserIds;

  /// List of comments on the post
  final List<Comment> comments;

  /// Whether this post is sponsored (ad)
  final bool isSponsored;

  /// List of user IDs tagged in this post
  final List<String> taggedUserIds;

  /// Location where the post was created
  final String? location;

  /// List of all media URLs (for carousel, reels, multiple images/videos)
  final List<String> mediaUrls;

  /// Type of post: 'image', 'video', 'carousel', 'reel'
  final String postType;

  /// Additional metadata like filters, effects, etc.
  final Map<String, dynamic>? metadata;

  /// Whether current user can edit this post
  final bool isEditable;

  /// URL of the reel video (if postType == 'reel')
  final String? reelUrl;

  /// Number of views (for videos/reels)
  final int viewCount;

  /// Duration of video (for video/reels)
  final Duration? videoDuration;

  /// Whether comments are allowed on this post
  final bool allowComments;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLikedByUser = false,
    this.isSavedByUser = false,
    this.likedUserIds = const [],
    this.comments = const [],
    this.isSponsored = false,
    this.taggedUserIds = const [],
    this.location,
    this.mediaUrls = const [],
    this.postType = 'image',
    this.metadata,
    this.isEditable = false,
    this.reelUrl,
    this.viewCount = 0,
    this.videoDuration,
    this.allowComments = true,
  });

  /// Deserialize from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userImageUrl: json['userImageUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      caption: json['caption'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
      isSavedByUser: json['isSavedByUser'] ?? false,
      likedUserIds: List<String>.from(json['likedUserIds'] ?? []),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSponsored: json['isSponsored'] ?? false,
      taggedUserIds: List<String>.from(json['taggedUserIds'] ?? []),
      location: json['location'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      postType: json['postType'] ?? 'image',
      metadata: json['metadata'] as Map<String, dynamic>?,
      isEditable: json['isEditable'] ?? false,
      reelUrl: json['reelUrl'],
      viewCount: json['viewCount'] ?? 0,
      videoDuration: json['videoDuration'] != null
          ? Duration(seconds: json['videoDuration'])
          : null,
      allowComments: json['allowComments'] ?? true,
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'isLikedByUser': isLikedByUser,
      'isSavedByUser': isSavedByUser,
      'likedUserIds': likedUserIds,
      'comments': comments.map((e) => e.toJson()).toList(),
      'isSponsored': isSponsored,
      'taggedUserIds': taggedUserIds,
      'location': location,
      'mediaUrls': mediaUrls,
      'postType': postType,
      'metadata': metadata,
      'isEditable': isEditable,
      'reelUrl': reelUrl,
      'viewCount': viewCount,
      'videoDuration': videoDuration?.inSeconds,
      'allowComments': allowComments,
    };
  }
}
