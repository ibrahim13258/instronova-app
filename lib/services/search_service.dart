import '../config/app_config.dart';
import 'package:flutter/foundation.dart';
// TODO: Removed GetX import
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';

class SearchService extends GetxService {
  final Dio _dio = Dio();

  final RxList<UserModel> _userResults = <UserModel>[].obs;
  final RxList<PostModel> _postResults = <PostModel>[].obs;
  final RxList<String> _trendingHashtags = <String>[].obs;
  final RxList<String> _recentSearches = <String>[].obs;

  // Getters
  List<UserModel> get userResults => _userResults;
  List<PostModel> get postResults => _postResults;
  List<String> get trendingHashtags => _trendingHashtags;
  List<String> get recentSearches => _recentSearches;

  // Search users
  Future<void> searchUsers(String query) async {
    try {
      Response response = await _dio.get('AppConfig.baseUrl/search/users', queryParameters: {
        'q': query,
      });
      _userResults.value = (response.data as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
      _addToRecentSearches(query);
    } catch (e) {
      debugPrint("Error searching users: $e");
    }
  }

  // Search posts
  Future<void> searchPosts(String query) async {
    try {
      Response response = await _dio.get('AppConfig.baseUrl/search/posts', queryParameters: {
        'q': query,
      });
      _postResults.value = (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
      _addToRecentSearches(query);
    } catch (e) {
      debugPrint("Error searching posts: $e");
    }
  }

  // Fetch trending hashtags
  Future<void> fetchTrendingHashtags() async {
    try {
      Response response = await _dio.get('AppConfig.baseUrl/search/trending_hashtags');
      _trendingHashtags.value = List<String>.from(response.data);
    } catch (e) {
      debugPrint("Error fetching trending hashtags: $e");
    }
  }

  // Add to recent searches
  void _addToRecentSearches(String query) {
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
    }
  }

  // Clear recent searches
  void clearRecentSearches() {
    _recentSearches.clear();
  }
}
