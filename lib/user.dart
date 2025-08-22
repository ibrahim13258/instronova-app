// models/user.dart
class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String profileImageUrl;
  final String? bio;
  final String? gender;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final bool isPrivate;
  final DateTime joinedDate;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    this.bio,
    this.gender,
    this.postCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isPrivate = false,
    required this.joinedDate,
  });
}
