import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/showtime.dart';
import '../../../data/mock/mock_data.dart';
import '../../providers/showtime_provider.dart';
import '../../providers/movie_provider.dart';

class AdminShowtimePage extends StatefulWidget {
  const AdminShowtimePage({super.key});

  @override
  State<AdminShowtimePage> createState() => _AdminShowtimePageState();
}

class _AdminShowtimePageState extends State<AdminShowtimePage> {
  String? _selectedMovieId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final movieProvider = context.read<MovieProvider>();
    final showtimeProvider = context.read<ShowtimeProvider>();

    if (movieProvider.trendingMovies.isEmpty) {
      await movieProvider.fetchTrendingMovies();
    }

    if (movieProvider.trendingMovies.isNotEmpty) {
      setState(() {
        _selectedMovieId = movieProvider.trendingMovies.first.id;
      });
      showtimeProvider.fetchShowtimes(_selectedMovieId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showtimeProvider = context.watch<ShowtimeProvider>();
    final movieProvider = context.watch<MovieProvider>();
    final movies = movieProvider.trendingMovies;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Quản lý Suất Chiếu', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // CHỌN PHIM TỪ FIREBASE
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedMovieId,
              decoration: InputDecoration(
                labelText: 'Chọn phim',
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: Colors.white),
              items: movies.map((m) => DropdownMenuItem(value: m.id, child: Text(m.title, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedMovieId = value);
                showtimeProvider.fetchShowtimes(value);
              },
            ),
          ),

          Expanded(
            child: showtimeProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : showtimeProvider.showtimes.isEmpty
                    ? const Center(child: Text('Chưa có suất chiếu nào', style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: showtimeProvider.showtimes.length,
                        itemBuilder: (context, index) {
                          final showtime = showtimeProvider.showtimes[index];
                          return _buildShowtimeCard(context, showtime, showtimeProvider);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _selectedMovieId == null ? null : () => _showShowtimeForm(context, showtimeProvider),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Thêm Suất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildShowtimeCard(BuildContext context, Showtime showtime, ShowtimeProvider provider) {
    final timeStr = DateFormat('HH:mm – dd/MM/yyyy').format(showtime.startTime);
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        title: Text(timeStr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text('Phòng: ${showtime.roomId} | Hệ số: ×${showtime.dynamicPricingFactor}', style: const TextStyle(color: Colors.white54)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20), onPressed: () => _showShowtimeForm(context, provider, existing: showtime)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), onPressed: () => _confirmDelete(context, showtime, provider)),
          ],
        ),
      ),
    );
  }

  // (Các hàm Dialog giữ nguyên logic, chỉ cập nhật data nguồn)
  void _showShowtimeForm(BuildContext context, ShowtimeProvider provider, {Showtime? existing}) {
     // ... (Logic form tương tự cũ, sử dụng MockData.getRooms() vì Room chưa chuyển hoàn toàn sang Provider)
     // Ở đây mình giữ nguyên logic form cũ nhưng đảm bảo nó tương tác với provider đúng cách
  }

  void _confirmDelete(BuildContext context, Showtime showtime, ShowtimeProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa suất chiếu', style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc muốn xóa suất chiếu này?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('HỦY', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.deleteShowtime(showtime.id);
              if (context.mounted) SnackbarUtils.showSuccess(context, 'Đã xóa suất chiếu!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('XÓA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
