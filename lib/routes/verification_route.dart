import 'package:get/get.dart';
import '../screens/verification_screen.dart';

class VerificationRoute {
  // Route path
  static const String path = '/verification';

  // GetPage for Verification screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const VerificationScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
