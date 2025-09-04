// providers/post_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/story.dart';
import '../config/app_config.dart'; // Add your API base URL here

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _userPosts = [];
  List<Story> _stories = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _page = 1;

  List<Post> get posts => _posts;
  List<Post> get userPosts => _userPosts;
  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;

  /// 🔹 Parse API errors
  String _parseError(dynamic error) {
    try {
      if (error is String) {
        final data = jsonDecode(error);
        if (data is Map && data.containsKey('message')) return data['message'];
      }
      return "An error occurred. Please try again.";
    } catch (_) {
      return "An error occurred. Please try again.";
    }
  }

  /// 🔹 Fetch initial posts
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    _page = 1;

    try {
      // TODO: Replace mock data with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _posts = List.generate(10, (index) => Post(
            id: 'p$index',
            userId: 'u${index % 5}',
            username: 'user${index % 5}',
            userImageUrl: 'https://example.com/avatar${index % 5}.jpg',
            imageUrl: 'https://example.com/post$index.jpg',
            caption: 'This is post #$index with some caption text',
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            likeCount: index * 3,
            commentCount: index,
            isLiked: index % 3 == 0,
            isSaved: index % 4 == 0,
          ));
      _stories = List.generate(10, (index) => Story(
            id: 's$index',
            userId: 'u${index % 5}',
            username: 'user${index % 5}',
            userImageUrl: 'https://example.com/avatar${index % 5}.jpg',
            storyUrl: 'https://example.com/story$index.jpg',
            timestamp: DateTime.now().subtract(Duration(hours: index)),
            isViewed: index % 2 == 0,
          ));
    } catch (error) {
      throw Exception(_parseError(error));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Fetch posts of current user
  Future<void> fetchUserPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace mock data with API call
      await Future.delayed(const Duration(seconds: 1));
      _userPosts = List.generate(15, (index) => Post(
            id: 'up$index',
            userId: '1', // Current user
            username: 'demo',
            userImageUrl: 'https://example.com/avatar.jpg',
            imageUrl: 'https://example.com/user_post$index.jpg',
            caption: 'This is my post #$index',
            timestamp: DateTime.now().subtract(Duration(days: index)),
            likeCount: index * 2,
            commentCount: index ~/ 2,
            isLiked: true,
            isSaved: index % 3 == 0,
            isPost: index < 10,
            isReel: index >= 10,
          ));
    } catch (error) {
      throw Exception(_parseError(error));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      // TODO: Replace mock data with actual API call using _page
      await Future.delayed(const Duration(seconds: 1));
      final morePosts = List.generate(5, (index) => Post(
            id: 'p${_posts.length + index}',
            userId: 'u${index % 5}',
            username: 'user${index % 5}',
            userImageUrl: 'https://example.com/avatar${index % 5}.jpg',
            imageUrl: 'https://example.com/post${_posts.length + index}.jpg',
            caption: 'Additional post #${_posts.length + index}',
            timestamp: DateTime.now().subtract(Duration(hours: _posts.length + index)),
            likeCount: (_posts.length + index) * 2,
            commentCount: (_posts.length + index) ~/ 2,
          ));
      _posts.addAll(morePosts);
      _page++;
    } catch (error) {
      throw Exception(_parseError(error));
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 🔹 Toggle like/unlike post
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        userImageUrl: post.userImageUrl,
        imageUrl: post.imageUrl,
        caption: post.caption,
        timestamp: post.timestamp,
        likeCount: post.isLiked ? post.likeCount - 1 : post.likeCount + 1,
        commentCount: post.commentCount,
        isLiked: !post.isLiked,
        isSaved: post.isSaved,
        isPost: post.isPost,
        isReel: post.isReel,
      );
      notifyListeners();

      // TODO: Call API to sync like/unlike
      // await http.post(Uri.parse('${AppConfig.baseUrl}/like/$postId'));
    }
  }

  /// 🔹 Toggle save/unsave post
  Future<void> toggleSave(String postId) async {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        username: post.username,
        userImageUrl: post.userImageUrl,
        imageUrl: post.imageUrl,
        caption: post.caption,
        timestamp: post.timestamp,
        likeCount: post.likeCount,
        commentCount: post.commentCount,
        isLiked: post.isLiked,
        isSaved: !post.isSaved,
        isPost: post.isPost,
        isReel: post.isReel,
      );
      notifyListeners();

      // TODO: Call API to sync save/unsave
      // await http.post(Uri.parse('${AppConfig.baseUrl}/save/$postId'));
    }
  }
}
