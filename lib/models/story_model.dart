// models/story_model.dart

class StoryModel {
  final String id; // Unique story ID
  final String userId; // User who posted the story
  final String userName; // User's display name
  final String userProfilePic; // URL of user's profile picture
  final String mediaUrl; // Image or video URL
  final String mediaType; // 'image' or 'video'
  final DateTime createdAt; // When story was posted
  final List<String> viewers; // List of user IDs who viewed the story
  final bool isViewed; // Whether current user viewed it

  StoryModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
    this.viewers = const [],
    this.isViewed = false,
  });

  // Factory method to create from JSON
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userProfilePic: json['userProfilePic'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? 'image',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      viewers: List<String>.from(json['viewers'] ?? []),
      isViewed: json['isViewed'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfilePic': userProfilePic,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdAt': createdAt.toIso8601String(),
      'viewers': viewers,
      'isViewed': isViewed,
    };
  }
}
