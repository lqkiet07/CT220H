import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Core & Routes
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

// --- IMPORTS REPOSITORIES (Interfaces) ---
import 'domain/repositories/movie_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/showtime_repository.dart';
import 'domain/repositories/ticket_repository.dart';

// --- IMPORTS REPOSITORIES (Implementations) ---
import 'data/repositories/movie_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/showtime_repository_impl.dart';
import 'data/repositories/ticket_repository_impl.dart';

// --- IMPORTS PROVIDERS ---
import 'presentation/providers/movie_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/showtime_provider.dart';
import 'presentation/providers/ticket_provider.dart';
import 'presentation/providers/booking_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo các Repository
  final movieRepository = MovieRepositoryImpl();
  final userRepository = UserRepositoryImpl();
  final showtimeRepository = ShowtimeRepositoryImpl();
  final ticketRepository = TicketRepositoryImpl();

  runApp(CinemaApp(
    movieRepository: movieRepository,
    userRepository: userRepository,
    showtimeRepository: showtimeRepository,
    ticketRepository: ticketRepository,
  ));
}

class CinemaApp extends StatefulWidget {
  final MovieRepository movieRepository;
  final UserRepository userRepository;
  final ShowtimeRepository showtimeRepository;
  final TicketRepository ticketRepository;

  const CinemaApp({
    super.key,
    required this.movieRepository,
    required this.userRepository,
    required this.showtimeRepository,
    required this.ticketRepository,
  });

  @override
  State<CinemaApp> createState() => _CinemaAppState();
}

class _CinemaAppState extends State<CinemaApp> {
  late final AuthProvider authProvider;
  late final AppRouter appRouter;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider(widget.userRepository);
    appRouter = AppRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Tiêm Repositories
        Provider<MovieRepository>.value(value: widget.movieRepository),
        Provider<UserRepository>.value(value: widget.userRepository),
        Provider<ShowtimeRepository>.value(value: widget.showtimeRepository),
        Provider<TicketRepository>.value(value: widget.ticketRepository),

        // 2. Khởi tạo State Providers
        ChangeNotifierProvider(
          create: (_) => MovieProvider(widget.movieRepository)..fetchTrendingMovies(),
        ),
        ChangeNotifierProvider.value(
          value: authProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => ShowtimeProvider(widget.showtimeRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketProvider(widget.ticketRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Cinema App CT220H',
        theme: AppTheme.darkTheme,
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}