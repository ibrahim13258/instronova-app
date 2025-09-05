import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool isViewed; // agar story already dekhi ho

  const StoryWidget({
    super.key,
    required this.imageUrl,
    required this.username,
    this.isViewed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isViewed
                ? null
                : const LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.purple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            border: isViewed
                ? Border.all(color: Colors.grey.shade300, width: 2)
                : null,
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 70,
          child: Text(
            username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isViewed ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
