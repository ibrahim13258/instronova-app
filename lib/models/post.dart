import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'comment.dart';
import 'post.dart';

/// Configuration for PostProvider
class PostConfig {
  static const String baseUrl = "http://YOUR_IP:5000/api/v1/posts";
  static const String wsUrl = "ws://YOUR_IP:5000/ws/posts";
  static const int maxMediaPerPost = 10;
  static const Duration cacheDuration = Duration(hours: 24);
}

/// Provider for managing posts with Instagram-level features
class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _savedPosts = [];
  List<Post> _reels = [];
  Map<String, VideoPlayerController> _videoControllers = {};
  Map<String, bool> _postLikes = {};
  Map<String, bool> _postSaves = {};
  Map<String, int> _postViewCounts = {};
  WebSocket? _postWebSocket;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final SharedPreferences _prefs;

  PostProvider._(this._prefs) {
    _loadCachedData();
    _initRealTimeFeatures();
  }

  /// Factory constructor
  static Future<PostProvider> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PostProvider._(prefs);
  }

  /// Getters
  List<Post> get posts => _posts;
  List<Post> get savedPosts => _savedPosts;
  List<Post> get reels => _reels;
  List<Post> get discoverPosts => _posts.where((post) => !post.isSponsored).toList();
  List<Post> get sponsoredPosts => _posts.where((post) => post.isSponsored).toList();

  /// 🔹 Initialize real-time features
  void _initRealTimeFeatures() {
    _setupConnectivityMonitoring();
    _setupPushNotifications();
    _connectWebSocket();
  }

  /// 🔹 Setup connectivity monitoring
  void _setupConnectivityMonitoring() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _connectWebSocket();
      } else {
        _disconnectWebSocket();
      }
    });
  }

  /// 🔹 Setup push notifications for mentions and interactions
  void _setupPushNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handlePostNotification(message.data);
    });
  }

  /// 🔹 Load cached data from SharedPreferences
  Future<void> _loadCachedData() async {
    final cachedPosts = _prefs.getString('cached_posts');
    final cachedSavedPosts = _prefs.getString('cached_saved_posts');
    final cachedReels = _prefs.getString('cached_reels');

    if (cachedPosts != null) {
      try {
        final List<dynamic> postsJson = jsonDecode(cachedPosts);
        _posts = postsJson.map((json) => Post.fromJson(json)).toList();
      } catch (e) {
        print('Error loading cached posts: $e');
      }
    }

    if (cachedSavedPosts != null) {
      try {
        final List<dynamic> savedJson = jsonDecode(cachedSavedPosts);
        _savedPosts = savedJson.map((json) => Post.fromJson(json)).toList();
      } catch (e) {
        print('Error loading cached saved posts: $e');
      }
    }

    if (cachedReels != null) {
      try {
        final List<dynamic> reelsJson = jsonDecode(cachedReels);
        _reels = reelsJson.map((json) => Post.fromJson(json)).toList();
      } catch (e) {
        print('Error loading cached reels: $e');
      }
    }

    notifyListeners();
  }

  /// 🔹 Save data to cache
  Future<void> _saveToCache() async {
    await Future.wait([
      _prefs.setString('cached_posts', jsonEncode(_posts.map((p) => p.toJson()).toList())),
      _prefs.setString('cached_saved_posts', jsonEncode(_savedPosts.map((p) => p.toJson()).toList())),
      _prefs.setString('cached_reels', jsonEncode(_reels.map((p) => p.toJson()).toList())),
    ]);
  }

  /// 🔹 Connect WebSocket for real-time updates
  Future<void> _connectWebSocket() async {
    if (_postWebSocket != null) return;

    try {
      final ws = await WebSocket.connect(PostConfig.wsUrl);
      _postWebSocket = ws;

      ws.listen(
        (data) {
          final message = jsonDecode(data);
          _handleWebSocketMessage(message);
        },
        onDone: () => _postWebSocket = null,
        onError: (error) => _postWebSocket = null,
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
    }
  }

  /// 🔹 Disconnect WebSocket
  void _disconnectWebSocket() {
    _postWebSocket?.close();
    _postWebSocket = null;
  }

  /// 🔹 Handle WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'];
    final data = message['data'];

    switch (type) {
      case 'like_update':
        _handleLikeUpdate(data);
        break;
      case 'comment_update':
        _handleCommentUpdate(data);
        break;
      case 'view_update':
        _handleViewUpdate(data);
        break;
      case 'share_update':
        _handleShareUpdate(data);
        break;
      case 'new_post':
        _handleNewPost(data);
        break;
      case 'post_deleted':
        _handlePostDeleted(data);
        break;
      case 'post_edited':
        _handlePostEdited(data);
        break;
    }
  }

  /// 🔹 Handle like updates
  void _handleLikeUpdate(Map<String, dynamic> data) {
    final postId = data['postId'];
    final likeCount = data['likeCount'];
    final isLiked = data['isLiked'];

    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        likeCount: likeCount,
        isLikedByUser: isLiked,
      );
      notifyListeners();
      _saveToCache();
    }
  }

  /// 🔹 Handle comment updates
  void _handleCommentUpdate(Map<String, dynamic> data) {
    final postId = data['postId'];
    final commentCount = data['commentCount'];

    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(commentCount: commentCount);
      notifyListeners();
      _saveToCache();
    }
  }

  /// 🔹 Handle view updates
  void _handleViewUpdate(Map<String, dynamic> data) {
    final postId = data['postId'];
    final viewCount = data['viewCount'];

    _postViewCounts[postId] = viewCount;

    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(viewCount: viewCount);
      notifyListeners();
      _saveToCache();
    }
  }

  /// 🔹 Handle share updates
  void _handleShareUpdate(Map<String, dynamic> data) {
    final postId = data['postId'];
    final shareCount = data['shareCount'];

    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(shareCount: shareCount);
      notifyListeners();
      _saveToCache();
    }
  }

  /// 🔹 Handle new posts
  void _handleNewPost(Map<String, dynamic> data) {
    final post = Post.fromJson(data);
    _posts.insert(0, post);
    notifyListeners();
    _saveToCache();
  }

  /// 🔹 Handle post deletion
  void _handlePostDeleted(Map<String, dynamic> data) {
    final postId = data['postId'];
    _posts.removeWhere((post) => post.id == postId);
    _savedPosts.removeWhere((post) => post.id == postId);
    _reels.removeWhere((post) => post.id == postId);
    notifyListeners();
    _saveToCache();
  }

  /// 🔹 Handle post edits
  void _handlePostEdited(Map<String, dynamic> data) {
    final post = Post.fromJson(data);
    
    final postIndex = _posts.indexWhere((p) => p.id == post.id);
    if (postIndex != -1) {
      _posts[postIndex] = post;
    }

    final savedIndex = _savedPosts.indexWhere((p) => p.id == post.id);
    if (savedIndex != -1) {
      _savedPosts[savedIndex] = post;
    }

    final reelIndex = _reels.indexWhere((p) => p.id == post.id);
    if (reelIndex != -1) {
      _reels[reelIndex] = post;
    }

    notifyListeners();
    _saveToCache();
  }

  /// 🔹 Handle post notifications
  void _handlePostNotification(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'mention':
        _handleMentionNotification(data);
        break;
      case 'like':
        _handleLikeNotification(data);
        break;
      case 'comment':
        _handleCommentNotification(data);
        break;
      case 'share':
        _handleShareNotification(data);
        break;
    }
  }

  /// 🔹 Handle mention notifications
  void _handleMentionNotification(Map<String, dynamic> data) {
    final postId = data['postId'];
    final mentionedBy = data['mentionedBy'];
    
    // Show notification to user
    print('You were mentioned by $mentionedBy in post $postId');
  }

  /// 🔹 Handle like notifications
  void _handleLikeNotification(Map<String, dynamic> data) {
    final postId = data['postId'];
    final likedBy = data['likedBy'];
    final likeCount = data['likeCount'];
    
    // Update local state
    _handleLikeUpdate({
      'postId': postId,
      'likeCount': likeCount,
      'isLiked': false, // This is for the current user's like status
    });
  }

  /// 🔹 Handle comment notifications
  void _handleCommentNotification(Map<String, dynamic> data) {
    final postId = data['postId'];
    final commentCount = data['commentCount'];
    final commentedBy = data['commentedBy'];
    
    _handleCommentUpdate({
      'postId': postId,
      'commentCount': commentCount,
    });
  }

  /// 🔹 Handle share notifications
  void _handleShareNotification(Map<String, dynamic> data) {
    final postId = data['postId'];
    final shareCount = data['shareCount'];
    
    _handleShareUpdate({
      'postId': postId,
      'shareCount': shareCount,
    });
  }

  /// 🔹 Fetch posts from backend
  Future<void> fetchPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('${PostConfig.baseUrl}?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsJson = jsonDecode(response.body);
        _posts = postsJson.map((json) => Post.fromJson(json)).toList();
        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// 🔹 Fetch saved posts
  Future<void> fetchSavedPosts({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('${PostConfig.baseUrl}/saved'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        final List<dynamic> savedJson = jsonDecode(response.body);
        _savedPosts = savedJson.map((json) => Post.fromJson(json)).toList();
        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to fetch saved posts');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to fetch saved posts: $e');
    }
  }

  /// 🔹 Fetch reels
  Future<void> fetchReels({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('${PostConfig.baseUrl}/reels?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> reelsJson = jsonDecode(response.body);
        _reels = reelsJson.map((json) => Post.fromJson(json)).toList();
        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to fetch reels');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to fetch reels: $e');
    }
  }

  /// 🔹 Like a post
  Future<void> likePost(String postId, {String? token}) async {
    try {
      // Optimistic update
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final oldPost = _posts[postIndex];
        _posts[postIndex] = oldPost.copyWith(
          likeCount: oldPost.likeCount + 1,
          isLikedByUser: true,
        );
        notifyListeners();
      }

      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/like'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode != 200) {
        // Revert optimistic update if failed
        if (postIndex != -1) {
          final oldPost = _posts[postIndex];
          _posts[postIndex] = oldPost.copyWith(
            likeCount: oldPost.likeCount - 1,
            isLikedByUser: false,
          );
          notifyListeners();
        }
        throw Exception('Failed to like post');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  /// 🔹 Unlike a post
  Future<void> unlikePost(String postId, {String? token}) async {
    try {
      // Optimistic update
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final oldPost = _posts[postIndex];
        _posts[postIndex] = oldPost.copyWith(
          likeCount: oldPost.likeCount - 1,
          isLikedByUser: false,
        );
        notifyListeners();
      }

      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/unlike'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode != 200) {
        // Revert optimistic update if failed
        if (postIndex != -1) {
          final oldPost = _posts[postIndex];
          _posts[postIndex] = oldPost.copyWith(
            likeCount: oldPost.likeCount + 1,
            isLikedByUser: true,
          );
          notifyListeners();
        }
        throw Exception('Failed to unlike post');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  /// 🔹 Save a post
  Future<void> savePost(String postId, {String? token}) async {
    try {
      // Optimistic update
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex] = _posts[postIndex].copyWith(isSavedByUser: true);
        notifyListeners();
      }

      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/save'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        // Refresh saved posts
        await fetchSavedPosts(token: token);
      } else {
        // Revert optimistic update
        if (postIndex != -1) {
          _posts[postIndex] = _posts[postIndex].copyWith(isSavedByUser: false);
          notifyListeners();
        }
        throw Exception('Failed to save post');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to save post: $e');
    }
  }

  /// 🔹 Unsave a post
  Future<void> unsavePost(String postId, {String? token}) async {
    try {
      // Optimistic update
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex] = _posts[postIndex].copyWith(isSavedByUser: false);
        notifyListeners();
      }

      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/unsave'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        // Refresh saved posts
        await fetchSavedPosts(token: token);
      } else {
        // Revert optimistic update
        if (postIndex != -1) {
          _posts[postIndex] = _posts[postIndex].copyWith(isSavedByUser: true);
          notifyListeners();
        }
        throw Exception('Failed to unsave post');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to unsave post: $e');
    }
  }

  /// 🔹 Share a post
  Future<void> sharePost(String postId, {String? token}) async {
    try {
      final post = _posts.firstWhere((p) => p.id == postId);
      
      // Generate deep link
      final deepLink = await _generateDeepLink(postId);
      
      // Share using platform share sheet
      await Share.share(
        'Check out this post by ${post.username}: $deepLink',
        subject: 'Post by ${post.username}',
      );

      // Track share
      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/share'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to track share');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to share post: $e');
    }
  }

  /// 🔹 Generate deep link for post
  Future<String> _generateDeepLink(String postId) async {
    // Implement deep link generation logic
    return 'https://yourapp.com/posts/$postId';
  }

  /// 🔹 Create a new post
  Future<void> createPost({
    required List<File> mediaFiles,
    required String caption,
    required String postType,
    List<String>? taggedUserIds,
    String? location,
    String privacy = 'public',
    bool allowComments = true,
    String? token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(PostConfig.baseUrl),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add media files
      for (int i = 0; i < mediaFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          mediaFiles[i].path,
          filename: 'media_$i.${mediaFiles[i].path.split('.').last}',
        ));
      }

      // Add other fields
      request.fields['caption'] = caption;
      request.fields['postType'] = postType;
      request.fields['privacy'] = privacy;
      request.fields['allowComments'] = allowComments.toString();
      
      if (taggedUserIds != null) {
        request.fields['taggedUserIds'] = jsonEncode(taggedUserIds);
      }
      
      if (location != null) {
        request.fields['location'] = location;
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 201) {
        final newPost = Post.fromJson(jsonDecode(response.body));
        _posts.insert(0, newPost);
        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to create post: ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// 🔹 Edit a post
  Future<void> editPost({
    required String postId,
    String? caption,
    List<File>? newMediaFiles,
    List<String>? taggedUserIds,
    String? location,
    String? privacy,
    bool? allowComments,
    String? token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${PostConfig.baseUrl}/$postId'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add new media files if provided
      if (newMediaFiles != null) {
        for (int i = 0; i < newMediaFiles.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'newMedia',
            newMediaFiles[i].path,
            filename: 'media_$i.${newMediaFiles[i].path.split('.').last}',
          ));
        }
      }

      // Add updated fields
      if (caption != null) request.fields['caption'] = caption;
      if (taggedUserIds != null) request.fields['taggedUserIds'] = jsonEncode(taggedUserIds);
      if (location != null) request.fields['location'] = location;
      if (privacy != null) request.fields['privacy'] = privacy;
      if (allowComments != null) request.fields['allowComments'] = allowComments.toString();

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final updatedPost = Post.fromJson(jsonDecode(response.body));
        
        // Update in all lists
        final postIndex = _posts.indexWhere((p) => p.id == postId);
        if (postIndex != -1) _posts[postIndex] = updatedPost;

        final savedIndex = _savedPosts.indexWhere((p) => p.id == postId);
        if (savedIndex != -1) _savedPosts[savedIndex] = updatedPost;

        final reelIndex = _reels.indexWhere((p) => p.id == postId);
        if (reelIndex != -1) _reels[reelIndex] = updatedPost;

        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to edit post: ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to edit post: $e');
    }
  }

  /// 🔹 Delete a post
  Future<void> deletePost(String postId, {String? token}) async {
    try {
      final response = await http.delete(
        Uri.parse('${PostConfig.baseUrl}/$postId'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        // Remove from all lists
        _posts.removeWhere((post) => post.id == postId);
        _savedPosts.removeWhere((post) => post.id == postId);
        _reels.removeWhere((post) => post.id == postId);
        
        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to delete post');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  /// 🔹 Report a post
  Future<void> reportPost(String postId, String reason, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/report'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to report post');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to report post: $e');
    }
  }

  /// 🔹 Block a user
  Future<void> blockUser(String userId, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/block/$userId'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode == 200) {
        // Remove posts from blocked user
        _posts.removeWhere((post) => post.userId == userId);
        _savedPosts.removeWhere((post) => post.userId == userId);
        _reels.removeWhere((post) => post.userId == userId);
        
        notifyListeners();
        _saveToCache();
      } else {
        throw Exception('Failed to block user');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  /// 🔹 Track post view (for videos/reels)
  Future<void> trackView(String postId, {String? token}) async {
    try {
      // Optimistic update
      _postViewCounts[postId] = (_postViewCounts[postId] ?? 0) + 1;

      final response = await http.post(
        Uri.parse('${PostConfig.baseUrl}/$postId/view'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (response.statusCode != 200) {
        // Revert optimistic update
        _postViewCounts[postId] = (_postViewCounts[postId] ?? 1) - 1;
        throw Exception('Failed to track view');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to track view: $e');
    }
  }

  /// 🔹 Initialize video controller for a post
  Future<VideoPlayerController> getVideoController(String videoUrl) async {
    if (_videoControllers.containsKey(videoUrl)) {
      return _videoControllers[videoUrl]!;
    }

    final controller = VideoPlayerController.network(videoUrl);
    await controller.initialize();
    _videoControllers[videoUrl] = controller;
    return controller;
  }

  /// 🔹 Dispose video controllers
  void disposeVideoControllers() {
    _videoControllers.forEach((url, controller) {
      controller.dispose();
    });
    _videoControllers.clear();
  }

  /// 🔹 Dispose resources
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _disconnectWebSocket();
    disposeVideoControllers();
    super.dispose();
  }
}

/// Extension for Post class to add copyWith method
extension PostCopyWith on Post {
  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? userImageUrl,
    String? imageUrl,
    String? caption,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLikedByUser,
    bool? isSavedByUser,
    List<String>? likedUserIds,
    List<Comment>? comments,
    bool? isSponsored,
    List<String>? taggedUserIds,
    String? location,
    List<String>? mediaUrls,
    String? postType,
    Map<String, dynamic>? metadata,
    bool? isEditable,
    String? reelUrl,
    int? viewCount,
    Duration? videoDuration,
    bool? allowComments,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLikedByUser: isLikedByUser ?? this.isLikedByUser,
      isSavedByUser: isSavedByUser ?? this.isSavedByUser,
      likedUserIds: likedUserIds ?? this.likedUserIds,
      comments: comments ?? this.comments,
      isSponsored: isSponsored ?? this.isSponsored,
      taggedUserIds: taggedUserIds ?? this.taggedUserIds,
      location: location ?? this.location,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      postType: postType ?? this.postType,
      metadata: metadata ?? this.metadata,
      isEditable: isEditable ?? this.isEditable,
      reelUrl: reelUrl ?? this.reelUrl,
      viewCount: viewCount ?? this.viewCount,
      videoDuration: videoDuration ?? this.videoDuration,
      allowComments: allowComments ?? this.allowComments,
    );
  }
}
