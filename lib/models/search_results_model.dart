// models/search_results_model.dart

class SearchResult {
  final String id; // Unique ID of the result (user, post, etc.)
  final String type; // "user", "post", "hashtag"
  final String title; // Username, hashtag, or post title
  final String subtitle; // Optional: user full name or post caption
  final String? imageUrl; // Profile picture or post thumbnail
  final bool isFollowing; // Only for user type
  final int? postCount; // Only for hashtag type

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.isFollowing = false,
    this.postCount,
  });

  // Factory constructor for JSON parsing
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'],
      isFollowing: json['isFollowing'] ?? false,
      postCount: json['postCount'],
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'isFollowing': isFollowing,
      'postCount': postCount,
    };
  }
}

// Example wrapper for search results page
class SearchResults {
  final List<SearchResult> results;
  final int totalCount;

  SearchResults({required this.results, required this.totalCount});

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      results: (json['results'] as List)
          .map((e) => SearchResult.fromJson(e))
          .toList(),
      totalCount: json['totalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
    };
  }
}
