// File: screens/feed_screen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../widgets/feed_post_item.dart';
import '../widgets/story_list.dart';

/// Home feed screen with real API integration skeleton.
/// This implementation removes dummy data and wires the screen
/// to a paginated HTTP GET on `${AppConfig.baseUrl}/posts`.
///
/// NOTE:
/// - Adjust the endpoint or queryParameters according to your backend.
/// - Map the `post` structure inside [FeedPostItem] as needed.
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final Dio _dio = Dio();

  final List<dynamic> _posts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  int _page = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore &&
        !_isLoading) {
      _fetchPosts(loadMore: true);
    }
  }

  Future<void> _fetchPosts({bool loadMore = false}) async {
    if (_isLoading || (loadMore && !_hasMore)) return;

    setState(() {
      if (loadMore) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _errorMessage = null;
      }
    });

    try {
      final response = await _dio.get(
        '\${AppConfig.baseUrl}/posts',
        queryParameters: {
          'page': _page,
          'limit': _limit,
        },
      );

      List<dynamic> items = [];
      final data = response.data;

      if (data is List) {
        items = data;
      } else if (data is Map && data['data'] is List) {
        items = data['data'] as List<dynamic>;
      }

      setState(() {
        if (loadMore) {
          _posts.addAll(items);
        } else {
          _posts
            ..clear()
            ..addAll(items);
        }

        if (items.length < _limit) {
          _hasMore = false;
        } else {
          _page += 1;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage ??= 'Failed to load feed. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    _page = 1;
    _hasMore = true;
    await _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchPosts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _posts.length + 2 + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Top stories section
          if (index == 0) {
            return const StoryList();
          }

          // Spacer under stories
          if (index == 1) {
            return const SizedBox(height: 8);
          }

          final postIndex = index - 2;

          if (postIndex >= _posts.length) {
            // Loading-more indicator at the end
            if (_isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final post = _posts[postIndex];

          return FeedPostItem(post: post);
        },
      ),
    );
  }
}
