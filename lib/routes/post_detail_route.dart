// GetX removed for Provider consistency
import '../screens/post_detail_screen.dart';

class PostDetailRoute {
  // Route path
  static const String path = '/post_detail';

  // GetPage for Post Detail screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const PostDetailScreen(),
    transition: Transition.rightToLeft, // slide transition for detail view
    transitionDuration: const Duration(milliseconds: 300),
  );
}
