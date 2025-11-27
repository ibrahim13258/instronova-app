// GetX removed for Provider consistency
import '../screens/likes_screen.dart';

class LikesRoute {
  // Route path
  static const String path = '/likes';

  // GetPage for Likes screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const LikesScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
