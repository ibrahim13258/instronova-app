// GetX removed for Provider consistency
import '../screens/saved_posts_screen.dart';

class SavedPostsRoute {
  // Route path
  static const String path = '/saved_posts';

  // GetPage for Saved Posts screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const SavedPostsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
