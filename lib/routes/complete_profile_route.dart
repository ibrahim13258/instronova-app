// GetX removed for Provider consistency
import '../screens/complete_profile_screen.dart';

class CompleteProfileRoute {
  // Route path
  static const String path = '/complete_profile';

  // GetPage for Complete Profile screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const CompleteProfileScreen(),
    transition: Transition.cupertino, // iOS style transition
    transitionDuration: const Duration(milliseconds: 400),
  );
}
