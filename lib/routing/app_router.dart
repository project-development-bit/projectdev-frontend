import 'package:cointiply_app/presentation/pages/main_tab_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const MainTabPage(),
    ),
  ],
);
