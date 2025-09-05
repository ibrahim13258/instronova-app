// models/search_model.dart

class SearchResult {
  final String id;
  final String username;
  final String fullName;
  final String profilePictureUrl;
  final bool isVerified;
  final String bio;

  SearchResult({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePictureUrl,
    this.isVerified = false,
    this.bio = '',
  });

  // JSON से convert करने के लिए factory method
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
      isVerified: json['is_verified'] ?? false,
      bio: json['bio'] ?? '',
    );
  }

  // Model को JSON में convert करने के लिए
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_picture_url': profilePictureUrl,
      'is_verified': isVerified,
      'bio': bio,
    };
  }
}

// Search results का list wrapper
class SearchResults {
  final List<SearchResult> results;

  SearchResults({required this.results});

  factory SearchResults.fromJson(List<dynamic> jsonList) {
    return SearchResults(
      results: jsonList.map((json) => SearchResult.fromJson(json)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return results.map((result) => result.toJson()).toList();
  }
}
