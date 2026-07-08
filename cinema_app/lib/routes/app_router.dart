import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/movie/movie_detail_page.dart';
import '../presentation/pages/booking/seat_selection_page.dart';
import '../presentation/pages/booking/showtime_selection_page.dart';
import '../presentation/pages/booking/checkout_page.dart';
import '../presentation/pages/booking/payment_success_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/booking/my_tickets_page.dart';
import '../presentation/pages/profile/account_settings_page.dart';
import '../presentation/pages/profile/support_page.dart';
import '../presentation/pages/admin/admin_dashboard_page.dart';

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
        path: '/showtimes/:id',
        builder: (BuildContext context, GoRouterState state) {
          final movieId = state.pathParameters['id']!;
          return ShowtimeSelectionPage(movieId: movieId);
        },
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (BuildContext context, GoRouterState state) {
          final movieId = state.pathParameters['id']!;
          return SeatSelectionPage(movieId: movieId);
        },
      ),
      GoRoute(
        path: '/checkout',
        builder: (BuildContext context, GoRouterState state) {
          final bookingData = state.extra as Map<String, dynamic>;
          return CheckoutPage(bookingData: bookingData);
        },
      ),
      GoRoute(
        path: '/success',
        builder: (BuildContext context, GoRouterState state) {
          final bookingData = state.extra as Map<String, dynamic>;
          return PaymentSuccessPage(bookingData: bookingData);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/my_tickets',
        builder: (BuildContext context, GoRouterState state) => const MyTicketsPage(),
      ),
      GoRoute(
        path: '/account_settings',
        builder: (BuildContext context, GoRouterState state) => const AccountSettingsPage(),
      ),
      GoRoute(
        path: '/support',
        builder: (BuildContext context, GoRouterState state) => const SupportPage(),
      ),
      GoRoute(
        path: '/admin_dashboard',
        builder: (BuildContext context, GoRouterState state) => const AdminDashboardPage(),
      ),
    ],
  );
}
