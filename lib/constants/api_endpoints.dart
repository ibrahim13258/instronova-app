class ApiEndpoints {
  // Base URL
  static const String baseUrl = "https://api.instronova.in/v1";

  // Authentication
  static const String login = "$baseUrl/auth/login";
  static const String signup = "$baseUrl/auth/signup";
  static const String logout = "$baseUrl/auth/logout";
  static const String forgotPassword = "$baseUrl/auth/forgot-password";
  static const String verifyOtp = "$baseUrl/auth/verify-otp";
  static const String completeProfile = "$baseUrl/auth/complete-profile";

  // User
  static const String profile = "$baseUrl/user/profile";
  static const String editProfile = "$baseUrl/user/edit-profile";
  static const String followers = "$baseUrl/user/followers";
  static const String following = "$baseUrl/user/following";

  // Posts
  static const String feed = "$baseUrl/posts/feed";
  static const String addPost = "$baseUrl/posts/add";
  static const String postDetail = "$baseUrl/posts/detail";
  static const String likePost = "$baseUrl/posts/like";
  static const String commentPost = "$baseUrl/posts/comment";
  static const String savedPosts = "$baseUrl/posts/saved";

  // Stories
  static const String stories = "$baseUrl/stories";
  static const String viewStory = "$baseUrl/stories/view";

  // Search
  static const String searchUsers = "$baseUrl/search/users";
  static const String searchPosts = "$baseUrl/search/posts";

  // Notifications
  static const String notifications = "$baseUrl/notifications";

  // Settings
  static const String accountSettings = "$baseUrl/settings/account";
  static const String privacySettings = "$baseUrl/settings/privacy";
  static const String securitySettings = "$baseUrl/settings/security";

  // Help & About
  static const String helpCenter = "$baseUrl/help-center";
  static const String aboutApp = "$baseUrl/about";
}
