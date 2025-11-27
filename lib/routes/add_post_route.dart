// GetX removed for Provider consistency
import '../screens/add_post_screen.dart';

class AddPostRoute {
  // Route path
  static const String path = '/add_post';

  // GetPage for Add Post screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const AddPostScreen(),
    transition: Transition.rightToLeft, // slide transition for adding post
    transitionDuration: const Duration(milliseconds: 300),
  );
}
