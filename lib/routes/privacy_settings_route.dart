import 'package:get/get.dart';
import '../screens/privacy_settings_screen.dart';

class PrivacySettingsRoute {
  // Route path
  static const String path = '/privacy_settings';

  // GetPage for Privacy Settings screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const PrivacySettingsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
