// GetX removed for Provider consistency
import '../screens/story_viewer_screen.dart';

class StoryViewerRoute {
  // Route path
  static const String path = '/story_viewer';

  // GetPage for Story Viewer screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const StoryViewerScreen(),
    transition: Transition.fade, // fade transition for stories
    transitionDuration: const Duration(milliseconds: 300),
  );
}
