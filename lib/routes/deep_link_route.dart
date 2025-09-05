import 'package:get/get.dart';
import '../screens/deep_link_screen.dart';

class DeepLinkRoute {
  // Route path
  static const String path = '/deep_link';

  // GetPage for Deep Link screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const DeepLinkScreen(),
    transition: Transition.downToUp, // slide transition from bottom
    transitionDuration: const Duration(milliseconds: 300),
  );
}
