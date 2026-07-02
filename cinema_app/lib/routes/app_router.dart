import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/movie/movie_detail_page.dart';
import '../presentation/pages/booking/seat_selection_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/movie/:id',
          builder: (BuildContext context, GoRouterState state) {
            final movieId = state.pathParameters['id']!;
            final heroTag = state.extra as String?;
            return MovieDetailPage(movieId: movieId, heroTag: heroTag);
          },
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (BuildContext context, GoRouterState state) {
          final movieId = state.pathParameters['id']!;
          return SeatSelectionPage(movieId: movieId);
        },
      ),
    ],
  );
}
