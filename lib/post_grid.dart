// widgets/post_grid.dart
import 'package:flutter/material.dart';
import '../models/post.dart';

class PostGrid extends StatelessWidget {
  final List<Post> posts;

  const PostGrid({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) => Image.network(
        posts[index].imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
