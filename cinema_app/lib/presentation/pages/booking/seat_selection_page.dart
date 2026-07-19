import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/algorithms/algorithms.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/seat.dart';
import '../../../data/models/showtime.dart';
import '../../../data/mock/mock_data.dart';
import '../../providers/movie_provider.dart';
import '../../providers/showtime_provider.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieId;
  final Showtime? showtime; // Truyền từ trang chọn suất chiếu

  const SeatSelectionPage({super.key, required this.movieId, this.showtime});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  Movie? _movie;
  Showtime? _showtime;
  late List<Seat> allSeats;
  Set<String> selectedSeatIds = {};
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

    // Nếu showtime chưa được truyền qua extra (do quay lại hoặc link trực tiếp), lấy cái đầu tiên
    if (widget.showtime != null) {
      _showtime = widget.showtime;
    } else {
      await showtimeProvider.fetchShowtimes(widget.movieId);
      if (showtimeProvider.showtimes.isNotEmpty) {
        _showtime = showtimeProvider.showtimes.first;
      }
    }

    // Lấy sơ đồ ghế từ Firebase (dựa trên showtimeId)
    if (_showtime != null) {
      await showtimeProvider.fetchBookedSeats(_showtime!.id);
      
      // Khởi tạo sơ đồ ghế trống từ MockData (vì Database chưa lưu toàn bộ sơ đồ)
      // Nhưng đánh dấu các ghế đã đặt từ Firebase
      final List<String> bookedIds = showtimeProvider.bookedSeats.map((s) => s.id).toList();
      allSeats = MockData.getSeats().map((s) {
        if (bookedIds.contains(s.id)) {
          return s.copyWith(status: SeatStatus.booked);
        }
        return s.copyWith();
      }).toList();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.booked) return;

    HapticFeedback.selectionClick();

    setState(() {
      if (selectedSeatIds.contains(seat.id)) {
        selectedSeatIds.remove(seat.id);
      } else {
        if (selectedSeatIds.length >= 8) {
          SnackbarUtils.showError(context, 'Bạn chỉ được chọn tối đa 8 ghế!');
          return;
        }
        selectedSeatIds.add(seat.id);
      }
    });
  }

  double _calculateTotalPrice() {
    if (_movie == null || _showtime == null) return 0;
    final selectedTypes = selectedSeatIds
        .map((id) => allSeats.firstWhere((s) => s.id == id).type)
        .toList();
    final result = PricingEngine.calculateTotal(
      seatTypes: selectedTypes,
      basePrice: _movie!.basePrice,
      showTime:  _showtime!.startTime,
    );
    // Áp dụng thêm hệ số từ Showtime (nếu có)
    return result.totalPrice * _showtime!.dynamicPricingFactor;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_movie == null || _showtime == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: const Center(child: Text('Thông tin không hợp lệ!')),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_movie!.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildPricingBanner(),
          _buildScreenArc(),
          const SizedBox(height: 32),
          
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: _buildSeatRows(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          _buildLegend(),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(currencyFormat),
    );
  }

  // (Các hàm build UI giữ nguyên như cũ, chỉ cập nhật data nguồn)
  Widget _buildPricingBanner() {
    final breakdown = PricingEngine.calculate(
      basePrice: _movie!.basePrice,
      seatType: SeatType.standard,
      showTime: _showtime!.startTime,
    );
    final NumberFormat fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(breakdown.timeSlotName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text('Giá cơ bản: ${fmt.format(breakdown.finalPrice)}', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScreenArc() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 40,
      width: MediaQuery.of(context).size.width * 0.7,
      child: CustomPaint(painter: ScreenPainter()),
    );
  }

  List<Widget> _buildSeatRows() {
    Map<String, List<Seat>> rows = {};
    for (var seat in allSeats) {
      rows.putIfAbsent(seat.row, () => []).add(seat);
    }
    return rows.entries.map((e) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20, child: Text(e.key, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          ...e.value.map((s) => _buildSeatWidget(s)),
        ],
      ),
    )).toList();
  }

  Widget _buildSeatWidget(Seat seat) {
    bool isSelected = selectedSeatIds.contains(seat.id);
    bool isBooked = seat.status == SeatStatus.booked;
    double width = seat.type == SeatType.sweetbox ? 60.0 : 30.0;
    
    return GestureDetector(
      onTap: () => _toggleSeat(seat),
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        width: width,
        height: 30,
        decoration: BoxDecoration(
          color: isBooked ? Colors.grey.shade800 : (isSelected ? AppColors.primary : AppColors.surface),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.white10),
        ),
        alignment: Alignment.center,
        child: Text(seat.number.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
      ),
    );
  }

  Widget _buildLegend() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 16,
        children: [
          _LegendItem(color: Colors.white54, label: 'Thường'),
          _LegendItem(color: AppColors.primary, label: 'Đang chọn'),
          _LegendItem(color: Colors.grey, label: 'Đã đặt'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(NumberFormat format) {
    double totalPrice = _calculateTotalPrice();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Color(0xFF1A1A24), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ghế: ${selectedSeatIds.join(", ")}', style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text(format.format(totalPrice), style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: selectedSeatIds.isEmpty ? null : () {
              context.push('/checkout', extra: {
                'movieId': widget.movieId,
                'showtimeId': _showtime!.id,
                'seats': selectedSeatIds.toList(),
                'totalPrice': totalPrice,
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            child: const Text('TIẾP TỤC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ]);
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary..style = PaintingStyle.stroke..strokeWidth = 2.0;
    final path = Path()..moveTo(0, size.height)..quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
