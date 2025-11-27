// GetX removed for Provider consistency
import '../screens/chat_screen.dart';

class ChatRoute {
  // Route path
  static const String path = '/chat';

  // GetPage for Chat screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const ChatScreen(),
    transition: Transition.rightToLeft, // horizontal slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
