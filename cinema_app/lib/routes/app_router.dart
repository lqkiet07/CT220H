import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // Màn hình tạm thời chờ bạn vẽ UI
          return const Scaffold(
            body: Center(
              child: Text(
                'Cinema App - Home Page\n(Sẽ làm ở Giai đoạn 2)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        },
      ),
    ],
  );
}
