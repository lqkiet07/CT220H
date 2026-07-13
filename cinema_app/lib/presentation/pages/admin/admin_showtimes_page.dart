import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../providers/showtime_provider.dart';
import '../../providers/movie_provider.dart';
import '../../../data/mock/mock_data.dart'; // To get room name

class AdminShowtimesPage extends StatelessWidget {
  const AdminShowtimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final showtimeProvider = context.watch<ShowtimeProvider>();
    final movieProvider = context.watch<MovieProvider>();
    
    final showtimes = showtimeProvider.showtimes;
    final movies = movieProvider.trendingMovies;
    final rooms = MockData.getRooms();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Quản lý Suất Chiếu', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: showtimeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : showtimeProvider.error.isNotEmpty
              ? Center(child: Text('Lỗi: ${showtimeProvider.error}', style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: showtimes.length,
                  itemBuilder: (context, index) {
                    final showtime = showtimes[index];
                    final movie = movies.firstWhere((m) => m.id == showtime.movieId, orElse: () => movies.first);
                    final room = rooms.firstWhere((r) => r.id == showtime.roomId, orElse: () => rooms.first);

                    return Card(
                      color: AppColors.surface,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('HH:mm').format(showtime.startTime),
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    DateFormat('dd/MM').format(showtime.startTime),
                                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Phòng: ${room.name}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  Text(
                                    'Hệ số giá: x${showtime.dynamicPricingFactor}',
                                    style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () {
                                    context.push('/admin_showtime_form/${showtime.id}');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _showDeleteConfirm(context, showtimeProvider, showtime.id, movie.title, showtime.startTime),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.push('/admin_showtime_form');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, ShowtimeProvider provider, String id, String title, DateTime time) {
    final timeStr = DateFormat('HH:mm dd/MM').format(time);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa Suất Chiếu', style: TextStyle(color: Colors.white)),
        content: Text('Bạn có chắc chắn muốn xóa suất chiếu lúc $timeStr của phim "$title" không?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('HỦY', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteShowtime(id);
              Navigator.pop(ctx);
              SnackbarUtils.showSuccess(context, 'Xóa suất chiếu thành công!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('XÓA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
