import 'package:get/get.dart';
import '../screens/search_screen.dart';

class SearchRoute {
  // Route path
  static const String path = '/search';

  // GetPage for Search screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const SearchScreen(),
    transition: Transition.rightToLeft, // horizontal slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
