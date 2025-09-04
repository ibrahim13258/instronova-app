class User {
  // Basic Info
  final String id;
  final String name;
  final String username;
  final String email;
  final String profileImageUrl;
  final String? bio;
  final String? gender;
  final DateTime joinedDate;

  // Authentication & Security
  final bool isVerified;
  final bool twoFactorEnabled;
  final List<String> loginMethods; // e.g., ['email', 'google', 'facebook']
  final String? passwordHash;

  // Social Info
  final int postCount;
  final int followerCount;
  final int followingCount;
  final List<String>? followersList; // user IDs
  final List<String>? followingList; // user IDs
  final List<String>? followRequests; // user IDs
  final bool isPrivate;
  final List<String>? blockedUsers;
  final List<String>? mutedUsers;

  // Content References
  final List<String>? postIds;
  final List<String>? reelIds;
  final List<String>? storyIds;
  final List<String>? savedPosts; // bookmarked post IDs
  final List<String>? recentlyViewedStories;

  // Privacy & Settings
  final bool allowTagging;
  final bool allowMentions;
  final String accountType; // personal / creator / business
  final bool notificationsEnabled;
  final bool darkMode;
  final String? languagePreference;

  // Analytics (for creator/business accounts)
  final int profileViews;
  final int reach;
  final int impressions;
  final double engagementRate;

  // Extra Metadata
  final DateTime? lastActive;
  final List<String>? deviceInfo; // devices where logged in

  User({
    // Basic Info
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    this.bio,
    this.gender,
    required this.joinedDate,

    // Authentication & Security
    this.isVerified = false,
    this.twoFactorEnabled = false,
    this.loginMethods = const ['email'],
    this.passwordHash,

    // Social Info
    this.postCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    this.followersList,
    this.followingList,
    this.followRequests,
    this.isPrivate = false,
    this.blockedUsers,
    this.mutedUsers,

    // Content References
    this.postIds,
    this.reelIds,
    this.storyIds,
    this.savedPosts,
    this.recentlyViewedStories,

    // Privacy & Settings
    this.allowTagging = true,
    this.allowMentions = true,
    this.accountType = 'personal',
    this.notificationsEnabled = true,
    this.darkMode = false,
    this.languagePreference,

    // Analytics
    this.profileViews = 0,
    this.reach = 0,
    this.impressions = 0,
    this.engagementRate = 0.0,

    // Extra Metadata
    this.lastActive,
    this.deviceInfo,
  });
}
