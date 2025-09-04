// providers/post_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import '../models/post.dart';
import '../models/story.dart';
import '../models/user.dart';
import '../config/app_config.dart';
import './user_provider.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _userPosts = [];
  List<Post> _savedPosts = [];
  List<Post> _pinnedPosts = [];
  List<Story> _stories = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _page = 1;
  final UserProvider _userProvider;

  PostProvider(this._userProvider);

  List<Post> get posts => _posts;
  List<Post> get userPosts => _userPosts;
  List<Post> get savedPosts => _savedPosts;
  List<Post> get pinnedPosts => _pinnedPosts;
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

  /// 🔹 Get authentication headers with token
  Map<String, String> _getAuthHeaders() {
    return {
      'Authorization': 'Bearer ${_userProvider.token}',
      'Content-Type': 'application/json',
    };
  }

  /// 🔹 Get multipart headers for file uploads
  Map<String, String> _getMultipartHeaders() {
    return {
      'Authorization': 'Bearer ${_userProvider.token}',
    };
  }

  /// 🔹 Fetch initial posts
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    _page = 1;

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/posts?page=$_page'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _posts = (data['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
        
        // Also fetch saved and pinned posts
        await _fetchSavedPosts();
        await _fetchPinnedPosts();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Fetch saved posts for current user
  Future<void> _fetchSavedPosts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/posts/saved'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _savedPosts = (data['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
      }
    } catch (error) {
      print('Error fetching saved posts: $error');
    }
  }

  /// 🔹 Fetch pinned posts for current user
  Future<void> _fetchPinnedPosts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/posts/pinned'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _pinnedPosts = (data['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
      }
    } catch (error) {
      print('Error fetching pinned posts: $error');
    }
  }

  /// 🔹 Fetch posts of current user
  Future<void> fetchUserPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/users/${_userProvider.userId}/posts'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userPosts = (data['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
      } else {
        throw Exception('Failed to load user posts: ${response.statusCode}');
      }
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
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/posts?page=${_page + 1}'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final morePosts = (data['posts'] as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();
        _posts.addAll(morePosts);
        _page++;
      }
    } catch (error) {
      throw Exception(_parseError(error));
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 🔹 Toggle like/unlike post
  Future<void> toggleLike(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    final userPostIndex = _userPosts.indexWhere((post) => post.id == postId);
    final savedPostIndex = _savedPosts.indexWhere((post) => post.id == postId);
    final pinnedPostIndex = _pinnedPosts.indexWhere((post) => post.id == postId);

    if (postIndex != -1) {
      final post = _posts[postIndex];
      final isLiked = !post.isLikedByUser;
      final newLikeCount = isLiked ? post.likeCount + 1 : post.likeCount - 1;
      
      // Update main posts list
      _posts[postIndex] = post.copyWith(
        isLikedByUser: isLiked,
        likeCount: newLikeCount,
        likedUserIds: isLiked 
          ? [...post.likedUserIds, _userProvider.userId]
          : post.likedUserIds.where((id) => id != _userProvider.userId).toList(),
      );

      // Update user posts if exists
      if (userPostIndex != -1) {
        _userPosts[userPostIndex] = _userPosts[userPostIndex].copyWith(
          isLikedByUser: isLiked,
          likeCount: newLikeCount,
        );
      }

      // Update saved posts if exists
      if (savedPostIndex != -1) {
        _savedPosts[savedPostIndex] = _savedPosts[savedPostIndex].copyWith(
          isLikedByUser: isLiked,
          likeCount: newLikeCount,
        );
      }

      // Update pinned posts if exists
      if (pinnedPostIndex != -1) {
        _pinnedPosts[pinnedPostIndex] = _pinnedPosts[pinnedPostIndex].copyWith(
          isLikedByUser: isLiked,
          likeCount: newLikeCount,
        );
      }

      notifyListeners();

      try {
        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/posts/$postId/like'),
          headers: _getAuthHeaders(),
          body: jsonEncode({'like': isLiked}),
        );

        if (response.statusCode != 200) {
          // Revert changes if API call fails
          _posts[postIndex] = post;
          if (userPostIndex != -1) _userPosts[userPostIndex] = post;
          if (savedPostIndex != -1) _savedPosts[savedPostIndex] = post;
          if (pinnedPostIndex != -1) _pinnedPosts[pinnedPostIndex] = post;
          notifyListeners();
          throw Exception('Failed to toggle like');
        }
      } catch (error) {
        // Revert changes on error
        _posts[postIndex] = post;
        if (userPostIndex != -1) _userPosts[userPostIndex] = post;
        if (savedPostIndex != -1) _savedPosts[savedPostIndex] = post;
        if (pinnedPostIndex != -1) _pinnedPosts[pinnedPostIndex] = post;
        notifyListeners();
        throw Exception(_parseError(error));
      }
    }
  }

  /// 🔹 Toggle save/unsave post
  Future<void> toggleSave(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    final userPostIndex = _userPosts.indexWhere((post) => post.id == postId);
    final savedPostIndex = _savedPosts.indexWhere((post) => post.id == postId);
    final pinnedPostIndex = _pinnedPosts.indexWhere((post) => post.id == postId);

    if (postIndex != -1) {
      final post = _posts[postIndex];
      final isSaved = !post.isSavedByUser;

      // Update main posts list
      _posts[postIndex] = post.copyWith(isSavedByUser: isSaved);

      // Update user posts if exists
      if (userPostIndex != -1) {
        _userPosts[userPostIndex] = _userPosts[userPostIndex].copyWith(isSavedByUser: isSaved);
      }

      // Update saved posts list
      if (isSaved) {
        _savedPosts.add(_posts[postIndex]);
      } else {
        _savedPosts.removeWhere((post) => post.id == postId);
      }

      // Update pinned posts if exists
      if (pinnedPostIndex != -1) {
        _pinnedPosts[pinnedPostIndex] = _pinnedPosts[pinnedPostIndex].copyWith(isSavedByUser: isSaved);
      }

      notifyListeners();

      try {
        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/posts/$postId/save'),
          headers: _getAuthHeaders(),
          body: jsonEncode({'save': isSaved}),
        );

        if (response.statusCode != 200) {
          // Revert changes if API call fails
          _posts[postIndex] = post;
          if (userPostIndex != -1) _userPosts[userPostIndex] = post;
          if (isSaved) {
            _savedPosts.removeWhere((p) => p.id == postId);
          } else {
            _savedPosts.add(post);
          }
          notifyListeners();
          throw Exception('Failed to toggle save');
        }
      } catch (error) {
        // Revert changes on error
        _posts[postIndex] = post;
        if (userPostIndex != -1) _userPosts[userPostIndex] = post;
        if (isSaved) {
          _savedPosts.removeWhere((p) => p.id == postId);
        } else {
          _savedPosts.add(post);
        }
        notifyListeners();
        throw Exception(_parseError(error));
      }
    }
  }

  /// 🔹 Share a post
  Future<void> sharePost(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final newShareCount = post.shareCount + 1;

      // Update local state optimistically
      _posts[postIndex] = post.copyWith(shareCount: newShareCount);
      notifyListeners();

      try {
        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/posts/$postId/share'),
          headers: _getAuthHeaders(),
        );

        if (response.statusCode != 200) {
          // Revert on failure
          _posts[postIndex] = post;
          notifyListeners();
          throw Exception('Failed to share post');
        }
      } catch (error) {
        _posts[postIndex] = post;
        notifyListeners();
        throw Exception(_parseError(error));
      }
    }
  }

  /// 🔹 Create a new post with multiple media
  Future<void> createPost({
    required List<File> mediaFiles,
    required String caption,
    required String postType,
    List<String> taggedUserIds = const [],
    String? location,
    String privacy = 'public',
    Duration? videoDuration,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.baseUrl}/posts'),
      );

      // Add headers
      request.headers.addAll(_getMultipartHeaders());

      // Add media files
      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
        final fileExtension = path.extension(file.path).replaceFirst('.', '');
        
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          file.path,
          contentType: MediaType.parse(mimeType),
          filename: 'media_$i.$fileExtension',
        ));
      }

      // Add other fields
      request.fields['caption'] = caption;
      request.fields['postType'] = postType;
      request.fields['taggedUserIds'] = jsonEncode(taggedUserIds);
      request.fields['location'] = location ?? '';
      request.fields['privacy'] = privacy;
      if (videoDuration != null) {
        request.fields['videoDuration'] = videoDuration.inMilliseconds.toString();
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newPost = Post.fromJson(data['post']);
        _posts.insert(0, newPost);
        _userPosts.insert(0, newPost);

        // Extract mentions and send notifications
        await _handleMentions(caption, newPost.id);
        
        notifyListeners();
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Handle mentions in captions and send notifications
  Future<void> _handleMentions(String caption, String postId) async {
    final mentionRegex = RegExp(r'@(\w+)');
    final mentions = mentionRegex.allMatches(caption);

    for (final match in mentions) {
      final username = match.group(1);
      if (username != null) {
        try {
          await http.post(
            Uri.parse('${AppConfig.baseUrl}/notifications/mention'),
            headers: _getAuthHeaders(),
            body: jsonEncode({
              'username': username,
              'postId': postId,
              'type': 'mention',
            }),
          );
        } catch (error) {
          print('Failed to send mention notification: $error');
        }
      }
    }
  }

  /// 🔹 Add comment to a post
  Future<void> commentPost(String postId, String text) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/posts/$postId/comments'),
        headers: _getAuthHeaders(),
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final updatedPost = Post.fromJson(data['post']);
        
        // Update post in all lists
        _updatePostInLists(updatedPost);
        notifyListeners();

        // Handle mentions in comment
        await _handleMentions(text, postId);
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    }
  }

  /// 🔹 Update post in all lists
  void _updatePostInLists(Post updatedPost) {
    final postIndex = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (postIndex != -1) _posts[postIndex] = updatedPost;

    final userPostIndex = _userPosts.indexWhere((post) => post.id == updatedPost.id);
    if (userPostIndex != -1) _userPosts[userPostIndex] = updatedPost;

    final savedPostIndex = _savedPosts.indexWhere((post) => post.id == updatedPost.id);
    if (savedPostIndex != -1) _savedPosts[savedPostIndex] = updatedPost;

    final pinnedPostIndex = _pinnedPosts.indexWhere((post) => post.id == updatedPost.id);
    if (pinnedPostIndex != -1) _pinnedPosts[pinnedPostIndex] = updatedPost;
  }

  /// 🔹 Edit post caption and media
  Future<void> editPost({
    required String postId,
    String? caption,
    List<File>? newMediaFiles,
    List<String>? taggedUserIds,
    String? location,
    String? privacy,
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${AppConfig.baseUrl}/posts/$postId'),
      );

      request.headers.addAll(_getMultipartHeaders());

      // Add new media files if provided
      if (newMediaFiles != null) {
        for (int i = 0; i < newMediaFiles.length; i++) {
          final file = newMediaFiles[i];
          final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
          request.files.add(await http.MultipartFile.fromPath(
            'media',
            file.path,
            contentType: MediaType.parse(mimeType),
          ));
        }
      }

      // Add other fields
      if (caption != null) request.fields['caption'] = caption;
      if (taggedUserIds != null) request.fields['taggedUserIds'] = jsonEncode(taggedUserIds);
      if (location != null) request.fields['location'] = location;
      if (privacy != null) request.fields['privacy'] = privacy;

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedPost = Post.fromJson(data['post']);
        _updatePostInLists(updatedPost);
        notifyListeners();
      } else {
        throw Exception('Failed to edit post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    }
  }

  /// 🔹 Delete a post
  Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/posts/$postId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        // Remove post from all lists
        _posts.removeWhere((post) => post.id == postId);
        _userPosts.removeWhere((post) => post.id == postId);
        _savedPosts.removeWhere((post) => post.id == postId);
        _pinnedPosts.removeWhere((post) => post.id == postId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    }
  }

  /// 🔹 Toggle pin/unpin post
  Future<void> togglePinPost(String postId) async {
    final postIndex = _userPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _userPosts[postIndex];
      final isPinned = !_pinnedPosts.any((p) => p.id == postId);

      try {
        final response = await http.post(
          Uri.parse('${AppConfig.baseUrl}/posts/$postId/pin'),
          headers: _getAuthHeaders(),
          body: jsonEncode({'pin': isPinned}),
        );

        if (response.statusCode == 200) {
          if (isPinned) {
            _pinnedPosts.add(post);
          } else {
            _pinnedPosts.removeWhere((p) => p.id == postId);
          }
          notifyListeners();
        } else {
          throw Exception('Failed to toggle pin');
        }
      } catch (error) {
        throw Exception(_parseError(error));
      }
    }
  }

  /// 🔹 Report a post
  Future<void> reportPost(String postId, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/posts/$postId/report'),
        headers: _getAuthHeaders(),
        body: jsonEncode({
          'reason': reason,
          'reporterId': _userProvider.userId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to report post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    }
  }

  /// 🔹 Block a user (and their posts)
  Future<void> blockUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/users/$userId/block'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        // Remove blocked user's posts from all lists
        _posts.removeWhere((post) => post.userId == userId);
        _userPosts.removeWhere((post) => post.userId == userId);
        _savedPosts.removeWhere((post) => post.userId == userId);
        notifyListeners();
      } else {
        throw Exception('Failed to block user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    }
  }

  /// 🔹 Increment view count for video/reel posts
  Future<void> incrementViewCount(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1 && _posts[postIndex].isVideo) {
      final post = _posts[postIndex];
      final newViewCount = (post.viewCount ?? 0) + 1;

      // Update local state optimistically
      _posts[postIndex] = post.copyWith(viewCount: newViewCount);
      notifyListeners();

      try {
        await http.post(
          Uri.parse('${AppConfig.baseUrl}/posts/$postId/view'),
          headers: _getAuthHeaders(),
        );
      } catch (error) {
        // Revert on error
        _posts[postIndex] = post;
        notifyListeners();
        print('Failed to update view count: $error');
      }
    }
  }

  /// 🔹 Get post analytics
  Future<Map<String, dynamic>> getPostAnalytics(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/posts/$postId/analytics'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch analytics: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(_parseError(error));
    }
  }

  /// 🔹 Validate media files before upload
  bool validateMediaFiles(List<File> files, {int maxCount = 10, int maxSizeMB = 100}) {
    if (files.isEmpty || files.length > maxCount) {
      throw Exception('Please select between 1 and $maxCount files');
    }

    for (final file in files) {
      final sizeInMB = file.lengthSync() / (1024 * 1024);
      if (sizeInMB > maxSizeMB) {
        throw Exception('File size cannot exceed $maxSizeMB MB');
      }

      final mimeType = lookupMimeType(file.path);
      if (mimeType == null || 
          (!mimeType.startsWith('image/') && !mimeType.startsWith('video/'))) {
        throw Exception('Only images and videos are allowed');
      }
    }

    return true;
  }
}
