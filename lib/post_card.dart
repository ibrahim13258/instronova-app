// widgets/post_card.dart
import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onViewPost;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    required this.onViewPost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with user info
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(post.userImageUrl),
              ),
              const SizedBox(width: 8),
              Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
        
        // Post image
        GestureDetector(
          onDoubleTap: onLike,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Action buttons
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : null,
                ),
                onPressed: onLike,
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: onComment,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: onShare,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: onSave,
              ),
            ],
          ),
        ),
        
        // Likes count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Liked by ${post.likeCount} people',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        
        // Caption
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' '),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),
        
        // Comments preview
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: GestureDetector(
            onTap: onViewPost,
            child: Text(
              'View all ${post.commentCount} comments',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        
        // Timestamp
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            _formatTimeAgo(post.timestamp),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
