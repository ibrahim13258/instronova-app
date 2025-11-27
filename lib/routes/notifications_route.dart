// GetX removed for Provider consistency
import '../screens/notifications_screen.dart';

class NotificationsRoute {
  // Route path
  static const String path = '/notifications';

  // GetPage for Notifications screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const NotificationsScreen(),
    transition: Transition.rightToLeft, // horizontal slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
