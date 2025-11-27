// GetX removed for Provider consistency
import '../screens/followers_screen.dart';

class FollowersRoute {
  // Route path
  static const String path = '/followers';

  // GetPage for Followers screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const FollowersScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
