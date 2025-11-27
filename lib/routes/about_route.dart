// GetX removed for Provider consistency
import '../screens/about_screen.dart';

class AboutRoute {
  // Route path
  static const String path = '/about';

  // GetPage for About screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const AboutScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
