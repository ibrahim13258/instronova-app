// models/story.dart
class Story {
  final String id;
  final String userId;
  final String username;
  final String userImageUrl;
  final String storyUrl;
  final DateTime timestamp;
  final bool isViewed;

  Story({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.storyUrl,
    required this.timestamp,
    this.isViewed = false,
  });
}
