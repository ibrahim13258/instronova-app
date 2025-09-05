// models/help_center_model.dart

class HelpCenterModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isResolved;

  HelpCenterModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isResolved = false,
  });

  // JSON से object बनाने के लिए
  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isResolved: json['isResolved'] ?? false,
    );
  }

  // Object को JSON में convert करने के लिए
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isResolved': isResolved,
    };
  }
}
