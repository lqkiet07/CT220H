import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/movie.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/movie_provider.dart';
import '../../../core/utils/snackbar_utils.dart';

class MovieDetailPage extends StatefulWidget {
  final String movieId;
  final String? heroTag;

  const MovieDetailPage({super.key, required this.movieId, this.heroTag});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? _movie;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovie();
  }

  void _loadMovie() async {
    final movieProvider = context.read<MovieProvider>();
    // Tìm phim trong list có sẵn
    final movie = movieProvider.trendingMovies.cast<Movie?>().firstWhere(
      (m) => m?.id == widget.movieId,
      orElse: () => null,
    );

    if (movie != null) {
      setState(() {
        _movie = movie;
        _isLoading = false;
      });
    } else {
      // Nếu chưa có (ví dụ: truy cập link trực tiếp), có thể fetch detail nếu cần
      // Tạm thời lấy từ list trending (đã fetch ở main)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_movie == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: const Center(child: Text('Không tìm thấy phim!')),
      );
    }

    final movie = _movie!;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // PHẦN POSTER PHIM TRÀN VIỀN
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width * 1.3,
            pinned: true,
            backgroundColor: AppColors.background,
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
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    onPressed: () {
                      final movieLink = 'cinema://movie/${movie.id}';
                      Clipboard.setData(ClipboardData(text: movieLink)).then((_) {
                        if (context.mounted) {
                          SnackbarUtils.showSuccess(
                            context,
                            'Đã sao chép liên kết phim! Chia sẻ ngay cho bạn bè.',
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.heroTag ?? 'poster_${movie.id}',
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.movie, size: 80, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
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
                          // TODO: Trailer
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    'Đây là một siêu phẩm điện ảnh bom tấn với những kỹ xảo hoành tráng và cốt truyện đầy cảm động. Một kiệt tác nghệ thuật thứ bảy mà bạn chắc chắn không thể bỏ lỡ.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      
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
                  offset: const Offset(0, 8),
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
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                context.push('/showtimes/${movie.id}');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num, color: Colors.white),
                  const SizedBox(width: 8),
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
