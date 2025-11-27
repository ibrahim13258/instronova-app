import 'package:flutter/foundation.dart';
// TODO: Removed GetX import
import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class PostService extends GetxService {
  final Dio _dio = Dio();

  final RxList<PostModel> _feedPosts = <PostModel>[].obs;
  final Rx<PostModel> _postDetail = PostModel().obs;
  final RxList<CommentModel> _comments = <CommentModel>[].obs;

  // Getters
  List<PostModel> get feedPosts => _feedPosts;
  PostModel get postDetail => _postDetail.value;
  List<CommentModel> get comments => _comments;

  // Fetch feed posts
  Future<void> fetchFeed() async {
    try {
      Response response = await _dio.get('https://api.example.com/posts/feed');
      _feedPosts.value = (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error fetching feed: $e");
    }
  }

  // Add a new post
  Future<void> addPost(PostModel newPost) async {
    try {
      Response response = await _dio.post(
        'https://api.example.com/posts',
        data: newPost.toJson(),
      );
      _feedPosts.insert(0, PostModel.fromJson(response.data)); // add to top of feed
    } catch (e) {
      debugPrint("Error adding post: $e");
    }
  }

  // Fetch post details
  Future<void> fetchPostDetail(String postId) async {
    try {
      Response response = await _dio.get('https://api.example.com/posts/$postId');
      _postDetail.value = PostModel.fromJson(response.data);
      await fetchComments(postId); // load comments for post
    } catch (e) {
      debugPrint("Error fetching post detail: $e");
    }
  }

  // Fetch comments for a post
  Future<void> fetchComments(String postId) async {
    try {
      Response response = await _dio.get('https://api.example.com/posts/$postId/comments');
      _comments.value = (response.data as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error fetching comments: $e");
    }
  }

  // Add a comment
  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      Response response = await _dio.post(
        'https://api.example.com/posts/$postId/comments',
        data: comment.toJson(),
      );
      _comments.add(CommentModel.fromJson(response.data));
    } catch (e) {
      debugPrint("Error adding comment: $e");
    }
  }

  // Like a post
  Future<void> likePost(String postId) async {
    try {
      await _dio.post('https://api.example.com/posts/$postId/like');
      await fetchPostDetail(postId); // refresh post detail
    } catch (e) {
      debugPrint("Error liking post: $e");
    }
  }

  // Unlike a post
  Future<void> unlikePost(String postId) async {
    try {
      await _dio.post('https://api.example.com/posts/$postId/unlike');
      await fetchPostDetail(postId); // refresh post detail
    } catch (e) {
      debugPrint("Error unliking post: $e");
    }
  }
}
