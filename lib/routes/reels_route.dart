// GetX removed for Provider consistency
import '../screens/reels_screen.dart';

class ReelsRoute {
  // Route path
  static const String path = '/reels';

  // GetPage for Reels screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const ReelsScreen(),
    transition: Transition.downToUp, // vertical slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
