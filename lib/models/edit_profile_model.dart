class EditProfileModel {
  String? username;
  String? fullName;
  String? bio;
  String? website;
  String? email;
  String? phoneNumber;
  String? gender;
  String? profileImageUrl;
  bool? isPrivate;

  EditProfileModel({
    this.username,
    this.fullName,
    this.bio,
    this.website,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profileImageUrl,
    this.isPrivate,
  });

  // JSON से Model बनाना
  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      username: json['username'],
      fullName: json['fullName'],
      bio: json['bio'],
      website: json['website'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      isPrivate: json['isPrivate'] ?? false,
    );
  }

  // Model को JSON में बदलना
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'bio': bio,
      'website': website,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'isPrivate': isPrivate,
    };
  }
}
