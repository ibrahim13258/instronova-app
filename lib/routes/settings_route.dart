// GetX removed for Provider consistency
import '../screens/settings_screen.dart';

class SettingsRoute {
  // Route path
  static const String path = '/settings';

  // GetPage for Settings screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const SettingsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
