import 'package:get/get.dart';
import '../screens/chat_list_screen.dart';

class ChatListRoute {
  // Route path
  static const String path = '/chat_list';

  // GetPage for ChatList screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const ChatListScreen(),
    transition: Transition.rightToLeft, // horizontal slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
