import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserService extends GetxService {
  final Dio _dio = Dio();
  final Rx<UserModel> _user = UserModel().obs;
  final RxList<UserModel> _followers = <UserModel>[].obs;
  final RxList<UserModel> _following = <UserModel>[].obs;

  // Getters
  UserModel get user => _user.value;
  List<UserModel> get followers => _followers;
  List<UserModel> get following => _following;

  // Fetch user profile
  Future<void> fetchUserProfile(String userId) async {
    try {
      Response response = await _dio.get('https://api.example.com/users/$userId');
      _user.value = UserModel.fromJson(response.data);
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  // Edit user profile
  Future<void> editUserProfile(UserModel updatedUser) async {
    try {
      Response response = await _dio.put(
        'https://api.example.com/users/${updatedUser.id}',
        data: updatedUser.toJson(),
      );
      _user.value = UserModel.fromJson(response.data);
    } catch (e) {
      debugPrint("Error updating profile: $e");
    }
  }

  // Fetch followers list
  Future<void> fetchFollowers(String userId) async {
    try {
      Response response = await _dio.get('https://api.example.com/users/$userId/followers');
      _followers.value = (response.data as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error fetching followers: $e");
    }
  }

  // Fetch following list
  Future<void> fetchFollowing(String userId) async {
    try {
      Response response = await _dio.get('https://api.example.com/users/$userId/following');
      _following.value = (response.data as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint("Error fetching following: $e");
    }
  }

  // Follow a user
  Future<void> followUser(String targetUserId) async {
    try {
      await _dio.post('https://api.example.com/users/$targetUserId/follow');
      await fetchFollowing(_user.value.id!); // refresh following list
    } catch (e) {
      debugPrint("Error following user: $e");
    }
  }

  // Unfollow a user
  Future<void> unfollowUser(String targetUserId) async {
    try {
      await _dio.post('https://api.example.com/users/$targetUserId/unfollow');
      await fetchFollowing(_user.value.id!); // refresh following list
    } catch (e) {
      debugPrint("Error unfollowing user: $e");
    }
  }
}
