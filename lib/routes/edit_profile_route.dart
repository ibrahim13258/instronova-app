// GetX removed for Provider consistency
import '../screens/edit_profile_screen.dart';

class EditProfileRoute {
  // Route path
  static const String path = '/edit_profile';

  // GetPage for EditProfile screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const EditProfileScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
