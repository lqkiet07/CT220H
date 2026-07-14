import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Core & Routes
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

// Repositories & Providers
import 'data/repositories/movie_repository_impl.dart';
import 'presentation/providers/movie_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'domain/repositories/movie_repository.dart';

void main() async {
  // 1. Đảm bảo Flutter Core được khởi tạo trước khi gọi Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Firebase với cấu hình tự động sinh ra từ lệnh CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Khởi tạo Repository (Lưu ý: Không còn truyền apiService vào đây nữa)
  final movieRepository = MovieRepositoryImpl();

  runApp(CinemaApp(
    movieRepository: movieRepository,
  ));
}

class CinemaApp extends StatelessWidget {
  final MovieRepository movieRepository;

  const CinemaApp({
    super.key,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieProvider(movieRepository)..fetchTrendingMovies(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Cinema App CT220H',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}