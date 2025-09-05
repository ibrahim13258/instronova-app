import 'package:get/get.dart';
import '../screens/home_screen.dart';

class HomeRoute {
  // Route path
  static const String path = '/home';

  // GetPage for Home screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const HomeScreen(),
    transition: Transition.fadeIn, // Smooth fade transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
