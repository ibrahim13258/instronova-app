import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/story_model.dart';

class StoryService extends GetxService {
  final Dio _dio = Dio();
  final RxList<StoryModel> _stories = <StoryModel>[].obs;

  // Getter
  List<StoryModel> get stories => _stories;

  // Fetch all stories
  Future<void> fetchStories() async {
    try {
      Response response = await _dio.get('https://api.example.com/stories');
      _stories.value = (response.data as List)
          .map((json) => StoryModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Error fetching stories: $e");
    }
  }

  // Upload a new story
  Future<void> uploadStory(String userId, String mediaUrl, {String? caption}) async {
    try {
      Response response = await _dio.post(
        'https://api.example.com/stories',
        data: {
          'userId': userId,
          'mediaUrl': mediaUrl,
          'caption': caption,
        },
      );
      _stories.add(StoryModel.fromJson(response.data));
    } catch (e) {
      print("Error uploading story: $e");
    }
  }

  // Mark story as viewed
  Future<void> markStoryViewed(String storyId, String viewerId) async {
    try {
      await _dio.post(
        'https://api.example.com/stories/$storyId/view',
        data: {'viewerId': viewerId},
      );
      // Optional: update local story as viewed
      int index = _stories.indexWhere((s) => s.id == storyId);
      if (index != -1) {
        _stories[index].viewedBy.add(viewerId);
        _stories.refresh();
      }
    } catch (e) {
      print("Error marking story viewed: $e");
    }
  }

  // Delete a story
  Future<void> deleteStory(String storyId) async {
    try {
      await _dio.delete('https://api.example.com/stories/$storyId');
      _stories.removeWhere((s) => s.id == storyId);
    } catch (e) {
      print("Error deleting story: $e");
    }
  }
}
