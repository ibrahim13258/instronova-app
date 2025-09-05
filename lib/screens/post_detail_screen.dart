// File: screens/post_detail_screen.dart
import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  int _likes = 120;
  bool _isLiked = false;
  bool _isSaved = false;
  final List<String> _comments = ['Nice post!', 'Amazing!', 'Love this!'];
  final TextEditingController _commentController = TextEditingController();

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  void _addComment(String comment) {
    if (comment.isNotEmpty) {
      setState(() {
        _comments.add(comment);
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post image placeholder
            Container(
              height: 300,
              color: Colors.grey[300],
              child: const Center(child: Text('Post Media')),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  Text('$_likes likes'),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleSave,
                    icon: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: 'username ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: 'This is an amazing post!'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('View all ${_comments.length} comments',
                  style: const TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 8),
            // Comments list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Text(_comments[index]),
                );
              },
            ),
            const SizedBox(height: 12),
            // Add comment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _addComment(_commentController.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '2 hours ago',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
