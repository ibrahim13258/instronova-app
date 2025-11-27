// GetX removed for Provider consistency
import '../screens/forgot_password_screen.dart';

class ForgotPasswordRoute {
  // Route path
  static const String path = '/forgot_password';

  // GetPage for Forgot Password screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const ForgotPasswordScreen(),
    transition: Transition.downToUp, // Slide from bottom
    transitionDuration: const Duration(milliseconds: 400),
  );
}
