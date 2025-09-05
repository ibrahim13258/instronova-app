import 'package:get/get.dart';
import '../screens/comments_screen.dart';

class CommentsRoute {
  // Route path
  static const String path = '/comments';

  // GetPage for Comments screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const CommentsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
