// GetX removed for Provider consistency
import '../screens/security_settings_screen.dart';

class SecuritySettingsRoute {
  // Route path
  static const String path = '/security_settings';

  // GetPage for Security Settings screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const SecuritySettingsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
