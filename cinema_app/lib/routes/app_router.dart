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
import '../presentation/pages/admin/admin_dashboard_page.dart';
import '../presentation/pages/admin/admin_movies_page.dart';
import '../presentation/pages/admin/admin_movie_form_page.dart';
import '../presentation/pages/admin/admin_showtimes_page.dart';
import '../presentation/pages/admin/admin_showtime_form_page.dart';
import '../presentation/pages/admin/admin_qr_scanner_page.dart';
import '../presentation/pages/admin/admin_customers_page.dart';
import '../presentation/pages/profile/account_settings_page.dart';
import '../presentation/pages/profile/support_page.dart';
import '../presentation/pages/booking/ticket_detail_page.dart';
import '../data/models/ticket.dart';
import '../presentation/providers/auth_provider.dart';
<<<<<<< HEAD
=======
import '../presentation/pages/admin/admin_qr_scanner_page.dart';
import '../presentation/pages/admin/admin_customers_page.dart';
>>>>>>> 24ec759 (feat(ui): update booking flow, route guard, QR scanner, deep links, and admin customer management)

class AppRouter {
  final AuthProvider authProvider;
  late final GoRouter router;

  AppRouter(this.authProvider) {
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isAdmin = authProvider.isAdmin;
        final location = state.matchedLocation;

        // Admin paths
        final adminRoutes = [
          '/admin_dashboard',
          '/admin_movies',
          '/admin_movie_form',
          '/admin_showtimes',
          '/admin_showtime_form',
          '/admin_qr_scanner',
          '/admin_customers'
        ];

        // Protected user paths
        final protectedRoutes = [
          '/checkout',
          '/success',
          '/my_tickets',
          '/ticket_detail',
          '/profile',
          '/account_settings'
        ];

        // 1. Check Admin access
        if (adminRoutes.any((route) => location.startsWith(route))) {
          if (!isLoggedIn || !isAdmin) {
            return '/login';
          }
        }

        // 2. Check User access
        if (protectedRoutes.any((route) => location.startsWith(route))) {
          if (!isLoggedIn) {
            return '/login';
          }
        }

        // 3. Prevent logged-in users from accessing Login / Register
        if (isLoggedIn && (location == '/login' || location == '/register')) {
          return isAdmin ? '/admin_dashboard' : '/';
        }

        return null; // Continue to the requested page
      },
      routes: <RouteBase>[
<<<<<<< HEAD
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/movie/:id',
=======
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/movie/:id',
>>>>>>> 24ec759 (feat(ui): update booking flow, route guard, QR scanner, deep links, and admin customer management)
          builder: (BuildContext context, GoRouterState state) {
            final movieId = state.pathParameters['id']!;
            final heroTag = state.extra as String?;
            return MovieDetailPage(movieId: movieId, heroTag: heroTag);
          },
<<<<<<< HEAD
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
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return SeatSelectionPage(
              movieId: movieId,
              showtimeId: extra['showtimeId'] as String? ?? '',
              roomName: extra['roomName'] as String? ?? 'Phòng chiếu',
              startTime: extra['startTime'] as String? ?? '',
            );
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
          path: '/ticket_detail',
          builder: (BuildContext context, GoRouterState state) {
            final ticket = state.extra as Ticket;
            return TicketDetailPage(ticket: ticket);
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
        GoRoute(
          path: '/admin_qr_scanner',
          builder: (BuildContext context, GoRouterState state) => const AdminQrScannerPage(),
        ),
        GoRoute(
          path: '/admin_customers',
          builder: (BuildContext context, GoRouterState state) => const AdminCustomersPage(),
        ),
        GoRoute(
          path: '/admin_movies',
          builder: (BuildContext context, GoRouterState state) => const AdminMoviesPage(),
        ),
        GoRoute(
          path: '/admin_movie_form',
          builder: (BuildContext context, GoRouterState state) => const AdminMovieFormPage(),
        ),
        GoRoute(
          path: '/admin_movie_form/:id',
          builder: (BuildContext context, GoRouterState state) {
            final movieId = state.pathParameters['id']!;
            return AdminMovieFormPage(movieId: movieId);
          },
        ),
        GoRoute(
          path: '/admin_showtimes',
          builder: (BuildContext context, GoRouterState state) => const AdminShowtimesPage(),
        ),
        GoRoute(
          path: '/admin_showtime_form',
          builder: (BuildContext context, GoRouterState state) => const AdminShowtimeFormPage(),
        ),
        GoRoute(
          path: '/admin_showtime_form/:id',
          builder: (BuildContext context, GoRouterState state) {
            final showtimeId = state.pathParameters['id']!;
            return AdminShowtimeFormPage(showtimeId: showtimeId);
          },
        ),
      ],
=======
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
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SeatSelectionPage(
            movieId: movieId,
            showtimeId: extra['showtimeId'] as String? ?? '',
            roomName: extra['roomName'] as String? ?? 'Phòng chiếu',
            startTime: extra['startTime'] as String? ?? '',
          );
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
        path: '/ticket_detail',
        builder: (BuildContext context, GoRouterState state) {
          final ticket = state.extra as Ticket;
          return TicketDetailPage(ticket: ticket);
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
      GoRoute(
        path: '/admin_qr_scanner',
        builder: (BuildContext context, GoRouterState state) => const AdminQrScannerPage(),
      ),
      GoRoute(
        path: '/admin_customers',
        builder: (BuildContext context, GoRouterState state) => const AdminCustomersPage(),
      ),
      GoRoute(
        path: '/admin_movies',
        builder: (BuildContext context, GoRouterState state) => const AdminMoviesPage(),
      ),
      GoRoute(
        path: '/admin_movie_form',
        builder: (BuildContext context, GoRouterState state) => const AdminMovieFormPage(),
      ),
      GoRoute(
        path: '/admin_movie_form/:id',
        builder: (BuildContext context, GoRouterState state) {
          final movieId = state.pathParameters['id']!;
          return AdminMovieFormPage(movieId: movieId);
        },
      ),
      GoRoute(
        path: '/admin_showtimes',
        builder: (BuildContext context, GoRouterState state) => const AdminShowtimesPage(),
      ),
      GoRoute(
        path: '/admin_showtime_form',
        builder: (BuildContext context, GoRouterState state) => const AdminShowtimeFormPage(),
      ),
      GoRoute(
        path: '/admin_showtime_form/:id',
        builder: (BuildContext context, GoRouterState state) {
          final showtimeId = state.pathParameters['id']!;
          return AdminShowtimeFormPage(showtimeId: showtimeId);
        },
      ),
    ],
>>>>>>> 24ec759 (feat(ui): update booking flow, route guard, QR scanner, deep links, and admin customer management)
    );
  }
}
