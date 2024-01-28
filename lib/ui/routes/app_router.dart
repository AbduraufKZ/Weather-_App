import 'package:go_router/go_router.dart';
import 'package:weather_app/ui/pages/home_page.dart';
import 'package:weather_app/ui/pages/search_page.dart';
import 'package:weather_app/ui/routes/app_routes.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchPage(),
      ),
    ],
  );
}
