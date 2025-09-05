// models/profile_screen_model.dart

class ProfileScreenModel {
  final String userId;
  final String username;
  final String fullName;
  final String profilePictureUrl;
  final String bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowing;
  final List<PostModel> posts; // User ke posts
  final List<StoryModel> stories; // User ke stories
  final List<SavedPostModel> savedPosts; // Saved posts if own profile
  final List<ReelModel> reels; // User ke reels
  final bool isCurrentUser; // Agar profile khud ka hai ya kisi aur ka

  ProfileScreenModel({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.profilePictureUrl,
    required this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.isFollowing,
    required this.posts,
    required this.stories,
    required this.savedPosts,
    required this.reels,
    required this.isCurrentUser,
  });
}

// Example dependent models
class PostModel {
  final String postId;
  final String imageUrl;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.imageUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });
}

class StoryModel {
  final String storyId;
  final String mediaUrl;
  final bool isViewed;

  StoryModel({
    required this.storyId,
    required this.mediaUrl,
    required this.isViewed,
  });
}

class SavedPostModel {
  final String postId;
  final String imageUrl;

  SavedPostModel({
    required this.postId,
    required this.imageUrl,
  });
}

class ReelModel {
  final String reelId;
  final String videoUrl;
  final int likesCount;
  final int commentsCount;

  ReelModel({
    required this.reelId,
    required this.videoUrl,
    required this.likesCount,
    required this.commentsCount,
  });
}
