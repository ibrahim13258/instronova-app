import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

/// Represents a comment on a post
@JsonSerializable(explicitToJson: true)
class Comment {
  /// Unique comment ID
  final String id;

  /// ID of the user who made the comment
  final String userId;

  /// Username of the commenter
  final String username;

  /// Profile picture URL of the commenter
  final String userImageUrl;

  /// Comment text content
  final String text;

  /// Timestamp when the comment was created
  final DateTime createdAt;

  /// Number of likes on this comment
  final int likeCount;

  /// Whether the current user has liked this comment
  final bool isLikedByUser;

  /// ID of the comment this is replying to (if any)
  final String? parentCommentId;

  /// List of user IDs mentioned in this comment
  final List<String> mentionedUserIds;

  /// Creates a new Comment instance
  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.text,
    required this.createdAt,
    this.likeCount = 0,
    this.isLikedByUser = false,
    this.parentCommentId,
    this.mentionedUserIds = const [],
  });

  /// Creates a Comment from JSON data
  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  /// Converts this Comment to JSON data
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  String toString() => 'Comment(id: $id, username: $username, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Settings specific to reel videos
@JsonSerializable(explicitToJson: true)
class ReelSettings {
  /// Whether the reel should autoplay
  final bool autoplay;

  /// Whether the reel should start muted
  final bool muteByDefault;

  /// Whether the reel should loop
  final bool loop;

  /// Whether to show video controls
  final bool showControls;

  /// Preferred video quality (low, medium, high, auto)
  final String videoQuality;

  /// Creates a new ReelSettings instance
  ReelSettings({
    this.autoplay = true,
    this.muteByDefault = true,
    this.loop = true,
    this.showControls = true,
    this.videoQuality = 'auto',
  });

  /// Creates ReelSettings from JSON data
  factory ReelSettings.fromJson(Map<String, dynamic> json) => _$ReelSettingsFromJson(json);

  /// Converts this ReelSettings to JSON data
  Map<String, dynamic> toJson() => _$ReelSettingsToJson(this);

  @override
  String toString() => 'ReelSettings(autoplay: $autoplay, mute: $muteByDefault)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReelSettings &&
        other.autoplay == autoplay &&
        other.muteByDefault == muteByDefault &&
        other.loop == loop &&
        other.showControls == showControls &&
        other.videoQuality == videoQuality;
  }

  @override
  int get hashCode => Object.hash(autoplay, muteByDefault, loop, showControls, videoQuality);
}

/// Details for promoted/sponsored posts
@JsonSerializable(explicitToJson: true)
class PromotionDetails {
  /// ID of the promotion campaign
  final String campaignId;

  /// Name of the advertiser/brand
  final String advertiserName;

  /// URL to the advertiser's website
  final String advertiserWebsite;

  /// Target audience for the promotion
  final String targetAudience;

  /// Budget for the promotion
  final double budget;

  /// Duration of the promotion in days
  final int durationDays;

  /// Whether the promotion is currently active
  final bool isActive;

  /// Start date of the promotion
  final DateTime startDate;

  /// End date of the promotion
  final DateTime endDate;

  /// Creates a new PromotionDetails instance
  PromotionDetails({
    required this.campaignId,
    required this.advertiserName,
    required this.advertiserWebsite,
    required this.targetAudience,
    required this.budget,
    required this.durationDays,
    required this.isActive,
    required this.startDate,
    required this.endDate,
  });

  /// Creates PromotionDetails from JSON data
  factory PromotionDetails.fromJson(Map<String, dynamic> json) => _$PromotionDetailsFromJson(json);

  /// Converts this PromotionDetails to JSON data
  Map<String, dynamic> toJson() => _$PromotionDetailsToJson(this);

  @override
  String toString() => 'PromotionDetails(advertiser: $advertiserName, budget: $budget)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PromotionDetails && other.campaignId == campaignId;
  }

  @override
  int get hashCode => campaignId.hashCode;
}

/// Represents an Instagram-style Post with advanced features
@JsonSerializable(explicitToJson: true)
class Post {
  /// Unique identifier for the post
  final String id;

  /// ID of the user who created the post
  final String userId;

  /// Username of the post creator
  final String username;

  /// Profile picture URL of the creator
  final String userImageUrl;

  /// Caption/text content of the post
  final String caption;

  /// Timestamp when the post was created
  final DateTime createdAt;

  /// Timestamp when the post was last updated
  final DateTime updatedAt;

  /// URLs to media content (images/videos)
  final List<String> mediaUrls;

  /// Type of media: 'image', 'video', 'reel', 'carousel'
  final String mediaType;

  /// URL for video thumbnail (optional)
  final String? thumbnailUrl;

  /// Duration of video in seconds (optional)
  final int? videoDuration;

  /// Current index for carousel navigation (optional)
  final int? carouselIndex;

  /// Number of likes on the post
  final int likeCount;

  /// Number of comments on the post
  final int commentCount;

  /// Number of times the post has been shared
  final int shareCount;

  /// Number of views (for videos/reels)
  final int viewCount;

  /// Whether the current user has liked this post
  final bool isLikedByUser;

  /// Whether the current user has saved this post
  final bool isSavedByUser;

  /// Recent comments on the post (limited to most recent)
  final List<Comment> recentComments;

  /// Visibility setting: 'public', 'followers', 'close_friends'
  final String visibility;

  /// Whether the post is pinned to the user's profile
  final bool isPinned;

  /// Whether comments are allowed on this post
  final bool allowComments;

  /// List of user IDs tagged in this post
  final List<String> taggedUsers;

  /// List of hashtags used in the post
  final List<String> hashtags;

  /// Whether the post has been reported
  final bool isReported;

  /// Whether the post is blocked/hidden
  final bool isBlocked;

  /// Whether the current user can edit this post
  final bool canEdit;

  /// Whether the current user can delete this post
  final bool canDelete;

  /// Shareable deep link for the post
  final String shareableLink;

  /// Settings specific to reel videos
  final ReelSettings? reelSettings;

  /// Whether this post is highlighted in user's story
  final bool storyHighlight;

  /// Geographic location tag (optional)
  final String? geoTag;

  /// List of product tags (for shoppable posts)
  final List<String> productTags;

  /// Whether this is an ad/sponsored post
  final bool adSponsored;

  /// Details about promotion (if sponsored post)
  final PromotionDetails? promotionDetails;

  /// Creates a new Post instance
  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.caption,
    required this.createdAt,
    required this.updatedAt,
    this.mediaUrls = const [],
    this.mediaType = 'image',
    this.thumbnailUrl,
    this.videoDuration,
    this.carouselIndex,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.viewCount = 0,
    this.isLikedByUser = false,
    this.isSavedByUser = false,
    this.recentComments = const [],
    this.visibility = 'public',
    this.isPinned = false,
    this.allowComments = true,
    this.taggedUsers = const [],
    this.hashtags = const [],
    this.isReported = false,
    this.isBlocked = false,
    this.canEdit = false,
    this.canDelete = false,
    this.shareableLink = '',
    this.reelSettings,
    this.storyHighlight = false,
    this.geoTag,
    this.productTags = const [],
    this.adSponsored = false,
    this.promotionDetails,
  });

  /// Creates a Post from JSON data
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  /// Converts this Post to JSON data
  Map<String, dynamic> toJson() => _$PostToJson(this);

  /// Creates a copy of this Post with updated values
  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? userImageUrl,
    String? caption,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? mediaUrls,
    String? mediaType,
    String? thumbnailUrl,
    int? videoDuration,
    int? carouselIndex,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    int? viewCount,
    bool? isLikedByUser,
    bool? isSavedByUser,
    List<Comment>? recentComments,
    String? visibility,
    bool? isPinned,
    bool? allowComments,
    List<String>? taggedUsers,
    List<String>? hashtags,
    bool? isReported,
    bool? isBlocked,
    bool? canEdit,
    bool? canDelete,
    String? shareableLink,
    ReelSettings? reelSettings,
    bool? storyHighlight,
    String? geoTag,
    List<String>? productTags,
    bool? adSponsored,
    PromotionDetails? promotionDetails,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaType: mediaType ?? this.mediaType,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoDuration: videoDuration ?? this.videoDuration,
      carouselIndex: carouselIndex ?? this.carouselIndex,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      viewCount: viewCount ?? this.viewCount,
      isLikedByUser: isLikedByUser ?? this.isLikedByUser,
      isSavedByUser: isSavedByUser ?? this.isSavedByUser,
      recentComments: recentComments ?? this.recentComments,
      visibility: visibility ?? this.visibility,
      isPinned: isPinned ?? this.isPinned,
      allowComments: allowComments ?? this.allowComments,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      hashtags: hashtags ?? this.hashtags,
      isReported: isReported ?? this.isReported,
      isBlocked: isBlocked ?? this.isBlocked,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
      shareableLink: shareableLink ?? this.shareableLink,
      reelSettings: reelSettings ?? this.reelSettings,
      storyHighlight: storyHighlight ?? this.storyHighlight,
      geoTag: geoTag ?? this.geoTag,
      productTags: productTags ?? this.productTags,
      adSponsored: adSponsored ?? this.adSponsored,
      promotionDetails: promotionDetails ?? this.promotionDetails,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, username: $username, caption: ${caption.length > 20 ? caption.substring(0, 20) + "..." : caption}, mediaType: $mediaType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
