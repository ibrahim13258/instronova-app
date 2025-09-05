// models/follower_model.dart

class Follower {
  final String id;          // User unique ID
  final String username;    // Username
  final String fullName;    // Full name
  final String profilePic;  // Profile picture URL
  final bool isFollowing;   // Current user is following or not
  final DateTime followedAt; // When followed

  Follower({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePic,
    required this.isFollowing,
    required this.followedAt,
  });

  // JSON deserialization
  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      profilePic: json['profile_pic'] as String,
      isFollowing: json['is_following'] as bool,
      followedAt: DateTime.parse(json['followed_at'] as String),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
      'is_following': isFollowing,
      'followed_at': followedAt.toIso8601String(),
    };
  }
}
