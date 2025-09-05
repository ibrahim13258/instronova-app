class LinkConstants {
  // Base scheme for the app
  static const String scheme = "myapp://";

  // Core deep link paths
  static const String home = "${scheme}home";
  static const String login = "${scheme}login";
  static const String signup = "${scheme}signup";

  // Profile
  static const String profileBase = "${scheme}profile/"; // Append userId
  static String profile(String userId) => "$profileBase$userId";

  // Post
  static const String postBase = "${scheme}post/"; // Append postId
  static String post(String postId) => "$postBase$postId";

  // Notifications
  static const String notifications = "${scheme}notifications";

  // Messages
  static const String messagesBase = "${scheme}messages/"; // Append chatId
  static String messages(String chatId) => "$messagesBase$chatId";

  // Settings
  static const String settings = "${scheme}settings";

  // Search
  static const String searchBase = "${scheme}search/"; // Append query
  static String search(String query) => "$searchBase$query";

  // Example external link
  static const String help = "https://myapp.com/help";
}
