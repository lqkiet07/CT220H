import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/movie.dart';
import '../../../data/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';

class MovieDetailPage extends StatelessWidget {
  final String movieId;
  final String? heroTag;

  const MovieDetailPage({super.key, required this.movieId, this.heroTag});

  @override
  Widget build(BuildContext context) {
    // TODO: Giai đoạn 2 - Thành viên A sẽ dùng context.read<MovieProvider>() hoặc API
    // Tạm thời tìm phim trực tiếp từ MockData
    final Movie? movie = MockData.getMovies().cast<Movie?>().firstWhere(
      (m) => m?.id == movieId,
      orElse: () => null,
    );

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: const Center(child: Text('Không tìm thấy phim!')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // PHẦN POSTER PHIM TRÀN VIỀN
          SliverAppBar(
            // Tự động tính toán chiều cao dựa trên chiều rộng màn hình (tỷ lệ gần 2:3)
            expandedHeight: MediaQuery.of(context).size.width * 1.3,
            pinned: true, // Khi cuộn lên sẽ ghim lại thành thanh AppBar
            backgroundColor: AppColors.background,
            // Thêm nút Back có nền đen mờ (Glassmorphism) chống lóa
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh poster phim có hiệu ứng Hero
                  Hero(
                    tag: heroTag ?? 'poster_${movie.id}',
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter, // Ưu tiên hiển thị từ trên cùng xuống để không mất chữ và mặt diễn viên
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.movie, size: 80, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // Hiệu ứng Gradient làm mờ ảnh hòa vào nền Đen ở bên dưới
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background,
                        ],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                  // Nút Play Trailer (Glassmorphism) nằm chính giữa
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: IconButton(
                        iconSize: 48,
                        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                        onPressed: () {
                          // TODO: Mở popup phát trailer
                          print('Phát trailer phim');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // PHẦN NỘI DUNG THÔNG TIN PHIM
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên phim và Nhãn độ tuổi
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'T18',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Khung Thông tin cơ bản (Glassmorphism style)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 22),
                        const SizedBox(width: 6),
                        Text(
                          '${movie.rating} / 10',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 24),
                        const Icon(Icons.access_time_rounded, color: Colors.grey, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${movie.durationMinutes} phút',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Thể loại phim (Hiển thị dạng các viên thuốc cách điệu Cyberpunk)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: movie.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tóm tắt phim (Phần chữ giả)
                  const Text(
                    'Nội dung phim',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đây là một siêu phẩm điện ảnh bom tấn với những kỹ xảo hoành tráng và cốt truyện đầy cảm động. '
                    'Một kiệt tác nghệ thuật thứ bảy mà bạn chắc chắn không thể bỏ lỡ trong dịp cuối tuần này. '
                    '\n\n(Đoạn nội dung tóm tắt này tạm thời được tạo giả lập vì Database hiện tại chưa thiết kế trường "synopsis").',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Đạo diễn & Diễn viên (Giả lập)
                  const Text(
                    'Đạo diễn & Diễn viên',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        // Tạo mảng tên ngẫu nhiên
                        final names = ['Lý Hải', 'Quách Ngọc Tuyên', 'Đinh Y Nhung', 'Tiết Cương', 'Thanh Thức', 'Khách mời'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: AppColors.surface,
                                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${index + 11}'), // Link ảnh giả lập khuôn mặt
                              ),
                              const SizedBox(height: 8),
                              Text(
                                names[index],
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100), // Chừa khoảng trống để không bị khuất bởi nút dưới cùng
                ],
              ),
            ),
          ),
        ],
      ),
      
      // NÚT MUA VÉ LUÔN NỔI LÊN TRÊN (BOTTOM STICKY BAR CÓ GLOW)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8), // Hiệu ứng Glow rực sáng dưới đáy
                ),
              ],
              gradient: const LinearGradient(
                colors: [Color(0xFFE50914), Color(0xFFFF512F)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent, // Tắt bóng mặc định để xài bóng của Container
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // Điều hướng sang trang Chọn Suất chiếu thay vì Chọn Ghế
                context.push('/showtimes/${movie.id}');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'ĐẶT VÉ NGAY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
