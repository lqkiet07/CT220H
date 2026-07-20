import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/showtime.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/movie_provider.dart';
import '../../providers/showtime_provider.dart';

class ShowtimeSelectionPage extends StatefulWidget {
  final String movieId;

  const ShowtimeSelectionPage({super.key, required this.movieId});

  @override
  State<ShowtimeSelectionPage> createState() => _ShowtimeSelectionPageState();
}

class _ShowtimeSelectionPageState extends State<ShowtimeSelectionPage> {
  DateTime _selectedDate = DateTime.now();
  Movie? _movie;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final movieProvider = context.read<MovieProvider>();
    final showtimeProvider = context.read<ShowtimeProvider>();

    _movie = movieProvider.trendingMovies.cast<Movie?>().firstWhere(
      (m) => m?.id == widget.movieId,
      orElse: () => null,
    );

    await showtimeProvider.fetchShowtimes(widget.movieId);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<DateTime> _generateDates() {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
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

    final dates = _generateDates();
    final showtimeProvider = context.watch<ShowtimeProvider>();
    
    // Lọc suất chiếu theo ngày được chọn
    final filteredShowtimes = showtimeProvider.showtimes.where((s) {
      return s.startTime.day == _selectedDate.day &&
             s.startTime.month == _selectedDate.month &&
             s.startTime.year == _selectedDate.year;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _movie!.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Chọn ngày',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    width: 70,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.white10,
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMM').format(date),
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd').format(date),
                          style: TextStyle(
                            fontSize: 22,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const Divider(color: Colors.white10, height: 32, thickness: 1),

          Expanded(
            child: filteredShowtimes.isEmpty 
              ? const Center(
                  child: Text('Không có suất chiếu nào cho ngày này.', style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredShowtimes.length,
                  itemBuilder: (context, index) {
                    final showtime = filteredShowtimes[index];
                    final timeString = DateFormat('HH:mm').format(showtime.startTime);
                    final isPast = showtime.startTime.isBefore(DateTime.now());

                    return Card(
                      color: AppColors.surface,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: const Icon(Icons.access_time, color: AppColors.primary),
                        title: Text(timeString, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text('Phòng: ${showtime.roomId}', style: const TextStyle(color: Colors.white70)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
                        enabled: !isPast,
                        onTap: () {
                           context.push(
                            '/booking/${widget.movieId}',
                            extra: {
                              'showtime': showtime,
                              'showtimeId': showtime.id,
                              'roomName': 'Phòng ${showtime.roomId}',
                              'startTime': showtime.startTime.toIso8601String(),
                            },
                          );
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
