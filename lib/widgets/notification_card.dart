import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String userName;
  final String userAvatarUrl;
  final String notificationText;
  final DateTime notificationTime;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.userName,
    required this.userAvatarUrl,
    required this.notificationText,
    required this.notificationTime,
    this.onTap,
  }) : super(key: key);

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        child: Row(
          children: [
            // User avatar
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userAvatarUrl),
            ),
            const SizedBox(width: 10),
            // Notification text & time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$userName ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: notificationText,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimeAgo(notificationTime),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Optional action icon (like follow back, etc.)
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
