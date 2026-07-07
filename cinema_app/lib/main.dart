import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chopper/chopper.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'data/remote/api_service.dart';
import 'data/remote/mock_interceptor.dart';
import 'data/local/database.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'presentation/providers/movie_provider.dart';
import 'presentation/providers/auth_provider.dart';

void main() {
  // Khởi tạo các Core Services
  final chopperClient = ChopperClient(
    baseUrl: Uri.parse('http://localhost:8080/api'),
    services: [
      ApiService.create(),
    ],
    interceptors: [
      MockInterceptor(), // Sử dụng MockInterceptor để giả lập Server
      HttpLoggingInterceptor(),
    ],
    converter: const JsonConverter(),
  );

  final apiService = chopperClient.getService<ApiService>();
  final appDatabase = AppDatabase();

  // Khởi tạo Repositories
  final movieRepository = MovieRepositoryImpl(apiService);

  runApp(CinemaApp(
    movieRepository: movieRepository,
  ));
}

class CinemaApp extends StatelessWidget {
  final MovieRepositoryImpl movieRepository;

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
