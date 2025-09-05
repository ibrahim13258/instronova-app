// File: screens/saved_posts_screen.dart
import 'package:flutter/material.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  List<String> savedPosts = []; // URLs of saved post images

  Future<void> _refreshPosts() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Example saved posts
      savedPosts = [
        'https://via.placeholder.com/150',
        'https://via.placeholder.com/150/0000FF',
        'https://via.placeholder.com/150/FF0000',
        'https://via.placeholder.com/150/00FF00',
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Posts'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: savedPosts.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'No saved posts yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: savedPosts.length,
                itemBuilder: (context, index) {
                  final postUrl = savedPosts[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to post detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostDetailScreen(postUrl: postUrl),
                        ),
                      );
                    },
                    child: Image.network(
                      postUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// Dummy PostDetailScreen for navigation
class PostDetailScreen extends StatelessWidget {
  final String postUrl;
  const PostDetailScreen({Key? key, required this.postUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Center(
        child: Image.network(postUrl),
      ),
    );
  }
}
