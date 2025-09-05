import 'package:get/get.dart';
import '../screens/profile_screen.dart';

class ProfileRoute {
  // Route path
  static const String path = '/profile';

  // GetPage for Profile screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const ProfileScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
