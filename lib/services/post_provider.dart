// TODO: Removed GetX import
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostProvider extends GetxController {
  // Feed posts
  var feedPosts = <PostModel>[].obs;

  // Selected post for detail view
  Rx<PostModel?> selectedPost = Rx<PostModel?>(null);

  // Loading states
  var isLoadingFeed = false.obs;
  var isLoadingPostDetail = false.obs;
  var isLikingPost = false.obs;
  var isAddingComment = false.obs;

  // Fetch feed posts
  Future<void> fetchFeed() async {
    try {
      isLoadingFeed.value = true;
      var posts = await PostService.getFeedPosts();
      feedPosts.assignAll(posts);
    } catch (e) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// TODO: GetX usage commented out
// // OLD: Get.snackbar('Error', 'Failed to load feed');    } finally {
      isLoadingFeed.value = false;
    }
  }

  // Fetch single post detail
  Future<void> fetchPostDetail(String postId) async {
    try {
      isLoadingPostDetail.value = true;
      PostModel? post = await PostService.getPostDetail(postId);
      selectedPost.value = post;
    } catch (e) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// TODO: GetX usage commented out
// // OLD: Get.snackbar('Error', 'Failed to load post detail');    } finally {
      isLoadingPostDetail.value = false;
    }
  }

  // Like / Unlike post
  Future<void> toggleLike(String postId) async {
    if (selectedPost.value == null) return;
    try {
      isLikingPost.value = true;
      bool liked = await PostService.toggleLike(postId);
      if (liked) {
        selectedPost.value!.likesCount++;
        selectedPost.value!.isLiked = true;
      } else {
        selectedPost.value!.likesCount--;
        selectedPost.value!.isLiked = false;
      }
      selectedPost.refresh();
    } catch (e) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// TODO: GetX usage commented out
// // OLD: Get.snackbar('Error', 'Failed to update like');    } finally {
      isLikingPost.value = false;
    }
  }

  // Add comment to post
  Future<void> addComment(String postId, String commentText) async {
    if (selectedPost.value == null) return;
    try {
      isAddingComment.value = true;
      var comment = await PostService.addComment(postId, commentText);
      selectedPost.value!.comments.add(comment);
      selectedPost.refresh();
    } catch (e) {
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// TODO: GetX usage commented out
// // OLD: Get.snackbar('Error', 'Failed to add comment');    } finally {
      isAddingComment.value = false;
    }
  }
}