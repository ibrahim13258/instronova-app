import 'dart:io';
import 'package:flutter/material.dart';
// GetX removed for Provider consistency
import '../models/story_model.dart';
import '../services/story_service.dart';

class StoryProvider extends GetxController {
  // List of stories for current user or feed
  var stories = <StoryModel>[].obs;

  // Current selected story index
  var currentStoryIndex = 0.obs;

  // Loading state for stories
  var isLoading = false.obs;

  // Upload state
  var isUploading = false.obs;

  // Selected media file for upload
  File? selectedMedia;

  // Fetch stories from service
  Future<void> fetchStories() async {
    try {
      isLoading.value = true;
      List<StoryModel> fetchedStories = await StoryService.getStories();
      stories.assignAll(fetchedStories);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Select story by index
  void selectStory(int index) {
    if (index >= 0 && index < stories.length) {
      currentStoryIndex.value = index;
    }
  }

  // Move to next story
  void nextStory() {
    if (currentStoryIndex.value < stories.length - 1) {
      currentStoryIndex.value += 1;
    }
  }

  // Move to previous story
  void previousStory() {
    if (currentStoryIndex.value > 0) {
      currentStoryIndex.value -= 1;
    }
  }

  // Set media file to upload
  void setMedia(File file) {
    selectedMedia = file;
  }

  // Upload story
  Future<void> uploadStory() async {
    if (selectedMedia == null) {
      Get.snackbar('Error', 'No media selected for upload');
      return;
    }
    try {
      isUploading.value = true;
      StoryModel uploadedStory = await StoryService.uploadStory(selectedMedia!);
      stories.insert(0, uploadedStory); // Add to top
      selectedMedia = null;
      Get.snackbar('Success', 'Story uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload story: $e');
    } finally {
      isUploading.value = false;
    }
  }

  // Delete story
  Future<void> deleteStory(String storyId) async {
    try {
      await StoryService.deleteStory(storyId);
      stories.removeWhere((story) => story.id == storyId);
      Get.snackbar('Deleted', 'Story deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete story: $e');
    }
  }
}
