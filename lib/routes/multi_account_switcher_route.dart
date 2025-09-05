import 'package:get/get.dart';
import '../screens/multi_account_switcher_screen.dart';

class MultiAccountSwitcherRoute {
  // Route path
  static const String path = '/multi_account_switcher';

  // GetPage for Multi Account Switcher screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const MultiAccountSwitcherScreen(),
    transition: Transition.rightToLeft, // slide transition from right
    transitionDuration: const Duration(milliseconds: 300),
  );
}
