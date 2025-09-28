import 'package:go_router/go_router.dart';
import 'views/home_page.dart';
import 'views/about_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
    ],
  );
}
