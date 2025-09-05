// models/about_model.dart

class AboutModel {
  final String appName;
  final String version;
  final String developer;
  final String contactEmail;
  final String website;
  final String description;

  AboutModel({
    required this.appName,
    required this.version,
    required this.developer,
    required this.contactEmail,
    required this.website,
    required this.description,
  });

  // JSON से convert करने के लिए
  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      appName: json['appName'] ?? '',
      version: json['version'] ?? '',
      developer: json['developer'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      website: json['website'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // JSON में convert करने के लिए
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'version': version,
      'developer': developer,
      'contactEmail': contactEmail,
      'website': website,
      'description': description,
    };
  }
}
