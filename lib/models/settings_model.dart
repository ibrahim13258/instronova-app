// models/settings_model.dart

class SettingsModel {
  bool pushNotifications;
  bool emailNotifications;
  bool darkMode;
  bool saveOriginalPhotos;
  bool storySharing;
  bool showActivityStatus;

  SettingsModel({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.darkMode = false,
    this.saveOriginalPhotos = true,
    this.storySharing = true,
    this.showActivityStatus = true,
  });

  // JSON से model create करना
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      pushNotifications: json['pushNotifications'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      darkMode: json['darkMode'] ?? false,
      saveOriginalPhotos: json['saveOriginalPhotos'] ?? true,
      storySharing: json['storySharing'] ?? true,
      showActivityStatus: json['showActivityStatus'] ?? true,
    );
  }

  // Model को JSON में convert करना
  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'darkMode': darkMode,
      'saveOriginalPhotos': saveOriginalPhotos,
      'storySharing': storySharing,
      'showActivityStatus': showActivityStatus,
    };
  }

  // Copy method for easy updates
  SettingsModel copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? darkMode,
    bool? saveOriginalPhotos,
    bool? storySharing,
    bool? showActivityStatus,
  }) {
    return SettingsModel(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      darkMode: darkMode ?? this.darkMode,
      saveOriginalPhotos: saveOriginalPhotos ?? this.saveOriginalPhotos,
      storySharing: storySharing ?? this.storySharing,
      showActivityStatus: showActivityStatus ?? this.showActivityStatus,
    );
  }
}
