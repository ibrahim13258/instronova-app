// models/privacy_model.dart

class PrivacyModel {
  bool isPrivateAccount;
  bool allowTagging;
  bool allowMessageRequests;
  bool showActivityStatus;
  bool shareProfileData;

  PrivacyModel({
    this.isPrivateAccount = false,
    this.allowTagging = true,
    this.allowMessageRequests = true,
    this.showActivityStatus = true,
    this.shareProfileData = true,
  });

  // JSON serialization
  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      isPrivateAccount: json['isPrivateAccount'] ?? false,
      allowTagging: json['allowTagging'] ?? true,
      allowMessageRequests: json['allowMessageRequests'] ?? true,
      showActivityStatus: json['showActivityStatus'] ?? true,
      shareProfileData: json['shareProfileData'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPrivateAccount': isPrivateAccount,
      'allowTagging': allowTagging,
      'allowMessageRequests': allowMessageRequests,
      'showActivityStatus': showActivityStatus,
      'shareProfileData': shareProfileData,
    };
  }

  // Copy with for updating specific fields
  PrivacyModel copyWith({
    bool? isPrivateAccount,
    bool? allowTagging,
    bool? allowMessageRequests,
    bool? showActivityStatus,
    bool? shareProfileData,
  }) {
    return PrivacyModel(
      isPrivateAccount: isPrivateAccount ?? this.isPrivateAccount,
      allowTagging: allowTagging ?? this.allowTagging,
      allowMessageRequests: allowMessageRequests ?? this.allowMessageRequests,
      showActivityStatus: showActivityStatus ?? this.showActivityStatus,
      shareProfileData: shareProfileData ?? this.shareProfileData,
    );
  }
}
