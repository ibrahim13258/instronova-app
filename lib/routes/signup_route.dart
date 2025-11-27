// GetX removed for Provider consistency
import '../screens/signup_screen.dart';

class SignupRoute {
  // Route path
  static const String path = '/signup';

  // GetPage for Signup screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const SignupScreen(),
    transition: Transition.rightToLeft, // Smooth slide effect
    transitionDuration: const Duration(milliseconds: 400),
  );
}
