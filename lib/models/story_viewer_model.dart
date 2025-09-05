// models/story_viewer_model.dart
class StoryViewerModel {
  final String storyId;       // Story का unique ID
  final String userId;        // Story बनाने वाले user का ID
  final String mediaUrl;      // Image/Video URL
  final String mediaType;     // 'image' या 'video'
  final DateTime createdAt;   // Story कब create हुई
  bool isViewed;              // User ने story देखी या नहीं
  final Duration? videoDuration; // Video होने पर duration

  StoryViewerModel({
    required this.storyId,
    required this.userId,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
    this.isViewed = false,
    this.videoDuration,
  });

  // JSON से Model बनाने के लिए
  factory StoryViewerModel.fromJson(Map<String, dynamic> json) {
    return StoryViewerModel(
      storyId: json['storyId'],
      userId: json['userId'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      createdAt: DateTime.parse(json['createdAt']),
      isViewed: json['isViewed'] ?? false,
      videoDuration: json['videoDuration'] != null
          ? Duration(seconds: json['videoDuration'])
          : null,
    );
  }

  // Model को JSON में बदलने के लिए
  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'userId': userId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdAt': createdAt.toIso8601String(),
      'isViewed': isViewed,
      'videoDuration': videoDuration?.inSeconds,
    };
  }
}
