import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostDetailWidget extends StatelessWidget {
  final String username;
  final String userProfilePic;
  final String postImage;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  const PostDetailWidget({
    Key? key,
    required this.username,
    required this.userProfilePic,
    required this.postImage,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userProfilePic),
            ),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.more_vert),
          ),

          // Post Image
          GestureDetector(
            onDoubleTap: () {
              // Like action
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                postImage,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Actions Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    // Like toggle
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.comment),
                  onPressed: () {
                    // Navigate to comments
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.paperPlane),
                  onPressed: () {
                    // Share post
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    // Save post
                  },
                ),
              ],
            ),
          ),

          // Likes count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$likesCount likes',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: caption,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // Comments count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'View all $commentsCount comments',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
