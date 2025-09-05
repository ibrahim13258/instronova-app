import 'package:flutter/material.dart';

class FollowersCard extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String fullName;
  final bool isFollowing;
  final VoidCallback onFollowToggle;

  const FollowersCard({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.fullName,
    required this.isFollowing,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          const SizedBox(width: 12),

          // Username & Full Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fullName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Follow / Following Button
          ElevatedButton(
            onPressed: onFollowToggle,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.white : Colors.blue,
              foregroundColor: isFollowing ? Colors.black : Colors.white,
              side: isFollowing
                  ? const BorderSide(color: Colors.grey)
                  : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(isFollowing ? 'Following' : 'Follow'),
          ),
        ],
      ),
    );
  }
}
