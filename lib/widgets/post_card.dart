import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String userProfilePic;
  final String postImage;
  final String caption;
  final int likes;
  final int comments;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({
    super.key,
    required this.username,
    required this.userProfilePic,
    required this.postImage,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userProfilePic),
            ),
            title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          // Post Image
          Image.network(postImage, fit: BoxFit.cover, width: double.infinity),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.favorite_border), onPressed: onLike),
                IconButton(icon: const Icon(Icons.comment_outlined), onPressed: onComment),
                IconButton(icon: const Icon(Icons.share_outlined), onPressed: onShare),
                const Spacer(),
                IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
              ],
            ),
          ),
          // Likes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('$likes likes', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RichText(
              text: TextSpan(
                text: username,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(text: ' $caption', style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),
          // Comments count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text('View all $comments comments', style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }
}
