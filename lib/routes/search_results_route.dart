import 'package:get/get.dart';
import '../screens/search_results_screen.dart';

class SearchResultsRoute {
  // Route path
  static const String path = '/search_results';

  // GetPage for Search Results screen
  static final GetPage page = GetPage(
    name: path,
    page: () => const SearchResultsScreen(),
    transition: Transition.rightToLeft, // slide transition
    transitionDuration: const Duration(milliseconds: 300),
  );
}
