import 'package:get/get.dart';

// Screens import
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/complete_profile_screen.dart';
import '../screens/home_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/reels_screen.dart';
import '../screens/search_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/chat_list_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/story_viewer_screen.dart';
import '../screens/add_post_screen.dart';
import '../screens/post_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/account_settings_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/security_settings_screen.dart';
import '../screens/help_center_screen.dart';
import '../screens/about_screen.dart';
import '../screens/saved_posts_screen.dart';
import '../screens/followers_screen.dart';
import '../screens/following_screen.dart';
import '../screens/likes_screen.dart';
import '../screens/comments_screen.dart';
import '../screens/search_results_screen.dart';
import '../screens/verification_screen.dart';
import '../screens/deep_link_screen.dart';
import '../screens/multi_account_switcher_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot_password';
  static const String completeProfile = '/complete_profile';
  static const String home = '/home';
  static const String feed = '/feed';
  static const String reels = '/reels';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String chatList = '/chat_list';
  static const String chat = '/chat';
  static const String storyViewer = '/story_viewer';
  static const String addPost = '/add_post';
  static const String postDetail = '/post_detail';
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
  static const String settings = '/settings';
  static const String accountSettings = '/account_settings';
  static const String privacySettings = '/privacy_settings';
  static const String securitySettings = '/security_settings';
  static const String helpCenter = '/help_center';
  static const String about = '/about';
  static const String savedPosts = '/saved_posts';
  static const String followers = '/followers';
  static const String following = '/following';
  static const String likes = '/likes';
  static const String comments = '/comments';
  static const String searchResults = '/search_results';
  static const String verification = '/verification';
  static const String deepLink = '/deep_link';
  static const String multiAccountSwitcher = '/multi_account_switcher';

  // Route pages
  static List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: completeProfile, page: () => const CompleteProfileScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: feed, page: () => const FeedScreen()),
    GetPage(name: reels, page: () => const ReelsScreen()),
    GetPage(name: search, page: () => const SearchScreen()),
    GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(name: chatList, page: () => const ChatListScreen()),
    GetPage(name: chat, page: () => const ChatScreen()),
    GetPage(name: storyViewer, page: () => const StoryViewerScreen()),
    GetPage(name: addPost, page: () => const AddPostScreen()),
    GetPage(name: postDetail, page: () => const PostDetailScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => const EditProfileScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: accountSettings, page: () => const AccountSettingsScreen()),
    GetPage(name: privacySettings, page: () => const PrivacySettingsScreen()),
    GetPage(name: securitySettings, page: () => const SecuritySettingsScreen()),
    GetPage(name: helpCenter, page: () => const HelpCenterScreen()),
    GetPage(name: about, page: () => const AboutScreen()),
    GetPage(name: savedPosts, page: () => const SavedPostsScreen()),
    GetPage(name: followers, page: () => const FollowersScreen()),
    GetPage(name: following, page: () => const FollowingScreen()),
    GetPage(name: likes, page: () => const LikesScreen()),
    GetPage(name: comments, page: () => const CommentsScreen()),
    GetPage(name: searchResults, page: () => const SearchResultsScreen()),
    GetPage(name: verification, page: () => const VerificationScreen()),
    GetPage(name: deepLink, page: () => const DeepLinkScreen()),
    GetPage(name: multiAccountSwitcher, page: () => const MultiAccountSwitcherScreen()),
  ];
}
