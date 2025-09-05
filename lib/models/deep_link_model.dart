// models/deep_link_model.dart

class DeepLinkModel {
  final String? linkId;         // Unique ID for the deep link
  final String? url;            // The actual deep link URL
  final String? targetScreen;   // Screen to navigate when link is opened
  final Map<String, dynamic>? parameters; // Extra params in the link
  final DateTime? createdAt;    // Link creation time
  final bool? isActive;         // Whether the link is still active

  DeepLinkModel({
    this.linkId,
    this.url,
    this.targetScreen,
    this.parameters,
    this.createdAt,
    this.isActive,
  });

  // JSON deserialization
  factory DeepLinkModel.fromJson(Map<String, dynamic> json) {
    return DeepLinkModel(
      linkId: json['linkId'] as String?,
      url: json['url'] as String?,
      targetScreen: json['targetScreen'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      isActive: json['isActive'] as bool?,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'linkId': linkId,
      'url': url,
      'targetScreen': targetScreen,
      'parameters': parameters,
      'createdAt': createdAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
