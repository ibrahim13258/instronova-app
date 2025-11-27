// GetX removed for Provider consistency
import '../screens/login_screen.dart';

class LoginRoute {
  static const String path = '/login';

  static final GetPage page = GetPage(
    name: path,
    page: () => const LoginScreen(),
    transition: Transition.fadeIn,
    // You can add bindings or middlewares here if needed
  );
}
