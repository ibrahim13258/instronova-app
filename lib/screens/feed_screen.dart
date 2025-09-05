// File: screens/feed_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/feed_post_item.dart';
import '../widgets/story_list.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> posts = List.generate(
    10,
    (index) => {
      "username": "user$index",
      "profileImage": "https://i.pravatar.cc/150?img=$index",
      "postImage": "https://picsum.photos/500/500?random=$index",
      "likes": 10 + index,
      "caption": "This is post $index",
    },
  );

  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        _loadMorePosts();
      }
    });
  }

  Future<void> _loadMorePosts() async {
    setState(() => isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate API call
    List<Map<String, dynamic>> newPosts = List.generate(
      5,
      (index) => {
        "username": "user${posts.length + index}",
        "profileImage":
            "https://i.pravatar.cc/150?img=${posts.length + index}",
        "postImage":
            "https://picsum.photos/500/500?random=${posts.length + index}",
        "likes": posts.length + index,
        "caption": "New post ${posts.length + index}",
      },
    );
    setState(() {
      posts.addAll(newPosts);
      isLoadingMore = false;
    });
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    setState(() {
      posts = List.generate(
        10,
        (index) => {
          "username": "user$index",
          "profileImage": "https://i.pravatar.cc/150?img=$index",
          "postImage": "https://picsum.photos/500/500?random=$index",
          "likes": 10 + index,
          "caption": "Refreshed post $index",
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const StoryList(),
            const Divider(),
            ...posts.map((post) => FeedPostItem(post: post)).toList(),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
