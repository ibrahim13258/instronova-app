// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../models/story.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/story_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<PostProvider>(context, listen: false).fetchPosts();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      try {
        await Provider.of<PostProvider>(context, listen: false).loadMorePosts();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more posts: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostProvider>(context).posts;
    final stories = Provider.of<PostProvider>(context).stories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instanova',
          style: TextStyle(
            fontFamily: 'Cursive',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => Navigator.pushNamed(context, '/messages'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInitialData,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Stories
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: stories.length,
                        itemBuilder: (ctx, index) => StoryCircle(
                          story: stories[index],
                          onTap: () => _viewStory(stories[index]),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    
                    // Posts
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (ctx, index) => PostCard(
                        post: posts[index],
                        onLike: () => _likePost(posts[index]),
                        onComment: () => _commentOnPost(posts[index]),
                        onShare: () => _sharePost(posts[index]),
                        onSave: () => _savePost(posts[index]),
                        onViewPost: () => _viewPost(posts[index]),
                      ),
                    ),
                    if (Provider.of<PostProvider>(context).isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/search');
          if (index == 2) _showCreateOptions();
          if (index == 3) Navigator.pushNamed(context, '/reels');
          if (index == 4) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  void _viewStory(Story story) {
    // Implement story viewer
  }

  void _likePost(Post post) {
    Provider.of<PostProvider>(context, listen: false).toggleLike(post.id);
  }

  void _commentOnPost(Post post) {
    // Implement comment functionality
  }

  void _sharePost(Post post) {
    // Implement share functionality
  }

  void _savePost(Post post) {
    Provider.of<PostProvider>(context, listen: false).toggleSave(post.id);
  }

  void _viewPost(Post post) {
    // Implement post detail view
  }

  void _showCreateOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Post'),
            onTap: () {
              Navigator.pop(ctx);
              _createPost();
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Reel'),
            onTap: () {
              Navigator.pop(ctx);
              _createReel();
            },
          ),
          ListTile(
            leading: const Icon(Icons.story),
            title: const Text('Story'),
            onTap: () {
              Navigator.pop(ctx);
              _createStory();
            },
          ),
        ],
      ),
    );
  }

  void _createPost() {
    // Implement post creation
  }

  void _createReel() {
    // Implement reel creation
  }

  void _createStory() {
    // Implement story creation
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
