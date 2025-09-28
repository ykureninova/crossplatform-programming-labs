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
        path: '/about/:index',
        builder: (context, state) {
          final index = int.parse(state.pathParameters['index']!);
          return AboutPage(index: index);
        },
      ),
    ],
  );
}
