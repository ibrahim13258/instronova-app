import 'package:get/get.dart';
import '../screens/following_screen.dart';

class FollowingRoute {
  // Route path
  static const String path = '/following';

  // GetPage for Following screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const FollowingScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
