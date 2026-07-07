import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/movie.dart';
import '../../widgets/movie_card.dart';
import '../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../providers/movie_provider.dart';
import '../../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final authProvider = context.watch<AuthProvider>();
    final _movies = movieProvider.trendingMovies;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authProvider.isLoggedIn ? '👋 Xin chào, ${authProvider.userName}' : '👋 Xin chào, Khách',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Text(
              'CT220H Cinema',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: AppColors.primary,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: authProvider.isLoggedIn 
                ? CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(authProvider.userAvatar),
                  )
                : const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              if (authProvider.isLoggedIn) {
                context.push('/profile');
              } else {
                context.push('/login');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieProvider.error.isNotEmpty
              ? Center(child: Text('Lỗi: ${movieProvider.error}', style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TIÊU ĐỀ 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phim Thịnh Hành',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text(
                          'Xem tất cả',
                          style: TextStyle(color: AppColors.primary),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // DANH SÁCH CUỘN NGANG (TRENDING)
              SizedBox(
                height: 260, // Chiều cao cố định cho danh sách trượt
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(), // Hiệu ứng nảy giật iOS
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: MovieCard(
                        width: 140, // Đặt chiều rộng cố định để cuộn ngang đẹp hơn
                        movie: _movies[index],
                        heroTag: 'poster_${_movies[index].id}', // Tag khớp với trang Detail
                        onTap: () {
                          // Điều hướng qua trang Chi tiết và truyền tag để Hero animate đúng ảnh
                          context.push(
                            '/movie/${_movies[index].id}',
                            extra: 'poster_${_movies[index].id}',
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // TIÊU ĐỀ 2
              const Text(
                'Đang Chiếu Tại Rạp',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // DANH SÁCH LƯỚI (NOW SHOWING)
              GridView.builder(
                shrinkWrap: true, // Ép GridView cuộn chung với SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Tắt cuộn độc lập của Grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Hiển thị 2 cột
                  childAspectRatio: 0.65, // Chỉnh tỷ lệ để Poster không bị méo
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(
                    movie: _movies[index],
                    heroTag: 'now_showing_${_movies[index].id}', // Tag khác để không bị trùng lặp
                    onTap: () {
                      // Điều hướng qua trang Chi tiết và truyền tag để Hero animate đúng ảnh
                      context.push(
                        '/movie/${_movies[index].id}',
                        extra: 'now_showing_${_movies[index].id}',
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.theaters), label: 'Rạp chiếu'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Vé của tôi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}
