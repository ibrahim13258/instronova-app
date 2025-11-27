// GetX removed for Provider consistency
import '../screens/feed_screen.dart';

class FeedRoute {
  // Route path
  static const String path = '/feed';

  // GetPage for Feed screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const FeedScreen(),
    transition: Transition.rightToLeft, // Slide effect
    transitionDuration: const Duration(milliseconds: 300),
  );
}
