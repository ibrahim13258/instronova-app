import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/api_client.dart';

class SavedPostsService extends GetxService {
  // RxList to hold saved posts
  final RxList<PostModel> savedPosts = <PostModel>[].obs;

  // API Client instance
  final ApiClient _apiClient = ApiClient();

  // Fetch all saved posts
  Future<void> fetchSavedPosts() async {
    try {
      final List<PostModel> posts = await _apiClient.getSavedPosts();
      savedPosts.assignAll(posts);
    } catch (e) {
// TODO: Replace GetX navigation: Get.snackbar('Error', 'Failed to fetch saved posts: $e');
    }
  }

  // Add post to saved posts
  Future<void> addToSaved(PostModel post) async {
    try {
      final bool success = await _apiClient.savePost(post.id);
      if (success) {
        savedPosts.add(post);
// TODO: Replace GetX navigation: Get.snackbar('Saved', 'Post added to saved posts');
      }
    } catch (e) {
// TODO: Replace GetX navigation: Get.snackbar('Error', 'Failed to save post: $e');
    }
  }

  // Remove post from saved posts
  Future<void> removeFromSaved(String postId) async {
    try {
      final bool success = await _apiClient.unsavePost(postId);
      if (success) {
        savedPosts.removeWhere((post) => post.id == postId);
// TODO: Replace GetX navigation: Get.snackbar('Removed', 'Post removed from saved posts');
      }
    } catch (e) {
// TODO: Replace GetX navigation: Get.snackbar('Error', 'Failed to remove post: $e');
    }
  }

  // Check if a post is saved
  bool isPostSaved(String postId) {
    return savedPosts.any((post) => post.id == postId);
  }
}