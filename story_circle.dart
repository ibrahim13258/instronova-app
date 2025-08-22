// widgets/story_circle.dart
import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryCircle extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: story.isViewed
                    ? null
                    : const LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(story.userImageUrl),
              ),
            ),
            const SizedBox(height: 4),
            Text(story.username, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
