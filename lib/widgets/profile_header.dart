import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final bool isCurrentUser;
  final VoidCallback onFollowPressed;

  const ProfileHeader({
    Key? key,
    required this.profileImageUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.isCurrentUser,
    required this.onFollowPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              const SizedBox(width: 16),
              // Stats Column
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Posts', 0), // Optional: Add post count
                    _buildStatColumn('Followers', followers),
                    _buildStatColumn('Following', following),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Username
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              username,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Bio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              bio,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Follow / Edit Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFollowPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: isCurrentUser ? Colors.grey : Colors.blue,
              ),
              child: Text(
                isCurrentUser ? 'Edit Profile' : 'Follow',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Column _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
