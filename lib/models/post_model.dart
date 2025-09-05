// models/post_model.dart

import 'package:flutter/foundation.dart';
import 'comment_model.dart';
import 'user_model.dart';

class PostModel {
  final String id; // Post unique ID
  final UserModel author; // Post author
  final String caption; // Post caption
  final List<String> mediaUrls; // Images or video URLs
  final DateTime createdAt; // Post creation time
  int likesCount; // Total likes
  int commentsCount; // Total comments
  bool isLikedByCurrentUser; // If current user liked
  List<CommentModel> comments; // Comments list

  PostModel({
    required this.id,
    required this.author,
    required this.caption,
    required this.mediaUrls,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByCurrentUser = false,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  // Like the post
  void like() {
    if (!isLikedByCurrentUser) {
      likesCount += 1;
      isLikedByCurrentUser = true;
    }
  }

  // Unlike the post
  void unlike() {
    if (isLikedByCurrentUser && likesCount > 0) {
      likesCount -= 1;
      isLikedByCurrentUser = false;
    }
  }

  // Add a comment
  void addComment(CommentModel comment) {
    comments.add(comment);
    commentsCount = comments.length;
  }

  // Remove a comment by ID
  void removeComment(String commentId) {
    comments.removeWhere((c) => c.id == commentId);
    commentsCount = comments.length;
  }

  // Convert PostModel to Map (for API or local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author.toMap(),
      'caption': caption,
      'mediaUrls': mediaUrls,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLikedByCurrentUser': isLikedByCurrentUser,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }

  // Create PostModel from Map (API response)
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      author: UserModel.fromMap(map['author']),
      caption: map['caption'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      isLikedByCurrentUser: map['isLikedByCurrentUser'] ?? false,
      comments: map['comments'] != null
          ? List<CommentModel>.from(
              map['comments'].map((c) => CommentModel.fromMap(c)))
          : [],
    );
  }
}
