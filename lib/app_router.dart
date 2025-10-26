import 'package:go_router/go_router.dart';
import 'views/home_page.dart';
import 'views/about_page.dart';
import 'views/github_page.dart';
import 'views/resume_form_page.dart';

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
      GoRoute(
        path: '/github',
        builder: (context, state) => const GithubPage(),
      ),
      GoRoute(
        path: '/resume_form',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final index = extra?['index'] as int?;
          return ResumeFormPage(index: index);
        },
      ),
    ],
  );
}
