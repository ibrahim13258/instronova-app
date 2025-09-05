import 'package:get/get.dart';
import '../screens/account_settings_screen.dart';

class AccountSettingsRoute {
  // Route path
  static const String path = '/account_settings';

  // GetPage for Account Settings screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const AccountSettingsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
