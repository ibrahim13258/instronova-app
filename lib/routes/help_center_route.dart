import 'package:get/get.dart';
import '../screens/help_center_screen.dart';

class HelpCenterRoute {
  // Route path
  static const String path = '/help_center';

  // GetPage for Help Center screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const HelpCenterScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
