import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/search_service.dart';

class SearchProvider extends GetxController {
  // List of users matching the search query
  var searchResults = <UserModel>[].obs;

  // Loading state
  var isLoading = false.obs;

  // Current search query
  var query = ''.obs;

  // Update search query
  void updateQuery(String newQuery) {
    query.value = newQuery;
    if (newQuery.isNotEmpty) {
      searchUsers(newQuery);
    } else {
      searchResults.clear();
    }
  }

  // Fetch search results from service
  Future<void> searchUsers(String query) async {
    try {
      isLoading.value = true;
      List<UserModel> results = await SearchService.searchUsers(query);
      searchResults.assignAll(results);
    } catch (e) {
// TODO: Replace GetX navigation: Get.snackbar('Error', 'Failed to fetch search results: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear search results
  void clearResults() {
    query.value = '';
    searchResults.clear();
  }
}