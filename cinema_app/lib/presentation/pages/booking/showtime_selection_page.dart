import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/showtime.dart';
import '../../../data/models/room.dart';
import '../../../core/theme/app_colors.dart';

class ShowtimeSelectionPage extends StatefulWidget {
  final String movieId;

  const ShowtimeSelectionPage({super.key, required this.movieId});

  @override
  State<ShowtimeSelectionPage> createState() => _ShowtimeSelectionPageState();
}

class _ShowtimeSelectionPageState extends State<ShowtimeSelectionPage> {
  DateTime _selectedDate = DateTime.now();
  late Movie _movie;
  List<Showtime> _showtimes = [];
  List<Room> _rooms = [];

  @override
  void initState() {
    super.initState();
    // Tạm thời dùng MockData để render UI
    _movie = MockData.getMovies().firstWhere((m) => m.id == widget.movieId);
    _showtimes = MockData.getShowtimes().where((s) => s.movieId == widget.movieId).toList();
    _rooms = MockData.getRooms();
  }

  // Tạo danh sách 7 ngày tới
  List<DateTime> _generateDates() {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LỊCH CHỌN NGÀY (DATE SELECTOR)
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

          // DANH SÁCH RẠP VÀ SUẤT CHIẾU
          Expanded(
            child: _showtimes.isEmpty 
              ? const Center(
                  child: Text('Không có suất chiếu nào cho ngày này.', style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    // Lọc suất chiếu theo rạp (giả lập đơn giản)
                    final roomShowtimes = _showtimes.where((s) => s.roomId == room.id).toList();
                    
                    if (roomShowtimes.isEmpty) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên Cụm Rạp
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                room.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Các nút chọn giờ chiếu (Pill shape)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: roomShowtimes.map((showtime) {
                              final timeString = DateFormat('HH:mm').format(showtime.startTime);
                              
                              // Logic kiểm tra vé đã quá hạn (so với thời điểm hiện tại)
                              // Nếu rạp thực tế, còn phải xem ngày đang chọn có phải hôm nay không
                              final isToday = _selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month;
                              final isPast = isToday && showtime.startTime.isBefore(DateTime.now());

                              return InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: isPast ? null : () {
                                  // Chuyển sang Trang Chọn Ghế và truyền ID của phim
                                  context.push('/booking/${widget.movieId}');
                                },
                                child: Opacity(
                                  opacity: isPast ? 0.3 : 1.0, // Làm mờ nếu đã qua giờ
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isPast ? AppColors.background : AppColors.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: isPast ? Colors.white10 : Colors.white24),
                                    ),
                                    child: Text(
                                      timeString,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isPast ? Colors.grey : AppColors.textPrimary,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white10),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
