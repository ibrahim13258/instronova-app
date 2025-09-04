// models/story.dart

import 'package:flutter/foundation.dart';

/// Ultra-Advanced Story model for Instagram-level features
class Story {
  /// Unique ID of the story
  final String id;

  /// User ID of the creator
  final String userId;

  /// Username of the creator
  final String username;

  /// Profile image of the creator
  final String userImageUrl;

  /// URLs of story media (image/video carousel)
  final List<String> mediaUrls;

  /// Type of each media: 'image', 'video', 'boomerang', etc.
  final List<String> mediaTypes;

  /// Timestamp when the story was created
  final DateTime timestamp;

  /// Expiration timestamp (usually 24 hours later)
  final DateTime expiryTimestamp;

  /// Has current user viewed the story
  final bool isViewed;

  /// List of user IDs who viewed the story
  final List<String> viewers;

  /// Allow replies / DMs
  final bool allowReplies;

  /// Allow reactions (emojis)
  final bool allowReactions;

  /// Is this story for close friends only
  final bool isCloseFriends;

  /// Users tagged in the story
  final List<String> taggedUserIds;

  /// Mentions in the story (like @username)
  final List<String> mentions;

  /// Location sticker
  final String? location;

  /// Hashtags used in story
  final List<String> hashtags;

  /// Music URL or track attached
  final String? musicUrl;

  /// AR/Filter/Effect metadata
  final Map<String, dynamic>? effects;

  /// Is story sponsored/ads
  final bool isSponsored;

  /// Optional link/CTA for sponsored story
  final String? actionUrl;

  Story({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.mediaUrls,
    required this.mediaTypes,
    required this.timestamp,
    required this.expiryTimestamp,
    this.isViewed = false,
    this.viewers = const [],
    this.allowReplies = true,
    this.allowReactions = true,
    this.isCloseFriends = false,
    this.taggedUserIds = const [],
    this.mentions = const [],
    this.location,
    this.hashtags = const [],
    this.musicUrl,
    this.effects,
    this.isSponsored = false,
    this.actionUrl,
  });

  /// JSON deserialization
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userImageUrl: json['userImageUrl'] as String,
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      mediaTypes: List<String>.from(json['mediaTypes'] ?? []),
      timestamp: DateTime.parse(json['timestamp'] as String),
      expiryTimestamp: DateTime.parse(json['expiryTimestamp'] as String),
      isViewed: json['isViewed'] ?? false,
      viewers: List<String>.from(json['viewers'] ?? []),
      allowReplies: json['allowReplies'] ?? true,
      allowReactions: json['allowReactions'] ?? true,
      isCloseFriends: json['isCloseFriends'] ?? false,
      taggedUserIds: List<String>.from(json['taggedUserIds'] ?? []),
      mentions: List<String>.from(json['mentions'] ?? []),
      location: json['location'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      musicUrl: json['musicUrl'],
      effects: json['effects'] != null
          ? Map<String, dynamic>.from(json['effects'])
          : null,
      isSponsored: json['isSponsored'] ?? false,
      actionUrl: json['actionUrl'],
    );
  }

  /// JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'mediaUrls': mediaUrls,
      'mediaTypes': mediaTypes,
      'timestamp': timestamp.toIso8601String(),
      'expiryTimestamp': expiryTimestamp.toIso8601String(),
      'isViewed': isViewed,
      'viewers': viewers,
      'allowReplies': allowReplies,
      'allowReactions': allowReactions,
      'isCloseFriends': isCloseFriends,
      'taggedUserIds': taggedUserIds,
      'mentions': mentions,
      'location': location,
      'hashtags': hashtags,
      'musicUrl': musicUrl,
      'effects': effects,
      'isSponsored': isSponsored,
      'actionUrl': actionUrl,
    };
  }
}
