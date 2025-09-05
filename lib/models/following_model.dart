// models/following_model.dart

class FollowingModel {
  final String id;
  final String username;
  final String fullName;
  final String profileImageUrl;
  final bool isFollowing;

  FollowingModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profileImageUrl,
    required this.isFollowing,
  });

  // JSON से model बनाने के लिए factory
  factory FollowingModel.fromJson(Map<String, dynamic> json) {
    return FollowingModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
      isFollowing: json['is_following'] ?? false,
    );
  }

  // Model को JSON में convert करने के लिए
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'is_following': isFollowing,
    };
  }
}
