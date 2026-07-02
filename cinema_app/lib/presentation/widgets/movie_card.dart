import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../core/theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double? width; // Cho phép tùy chỉnh độ rộng (Dùng cho cuộn ngang)
  final String heroTag; // Phân biệt các thẻ Hero để tránh trùng lặp

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.heroTag,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withOpacity(0.2), // Màu hiệu ứng gợn sóng
        highlightColor: AppColors.primary.withOpacity(0.1),
        child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster phim (Bo góc mượt mà + Đổ bóng)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.movie_creation_outlined, color: Colors.grey, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Tên phim
            Text(
              movie.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Cắt chữ dài bằng dấu ...
            ),
            const SizedBox(height: 4),
            // Đánh giá sao
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  movie.rating.toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
