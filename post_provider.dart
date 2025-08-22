// providers/post_provider.dart
import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../models/story.dart';

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

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Implement API call to fetch posts
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demo
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
      
      _page = 1;
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserPosts() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Implement API call to fetch user posts
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demo
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
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_isLoadingMore) return;
    
    _isLoadingMore = true;
    notifyListeners();
    
    try {
      // Implement API call to load more posts
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demo
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
      rethrow;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
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
      );
      notifyListeners();
    }
  }

  void toggleSave(String postId) {
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
      );
      notifyListeners();
    }
  }
}
