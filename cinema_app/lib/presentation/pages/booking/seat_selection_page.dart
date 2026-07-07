import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/seat.dart';
import '../../../data/mock/mock_data.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieId;

  const SeatSelectionPage({super.key, required this.movieId});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late Movie? movie;
  late List<Seat> allSeats;
  Set<String> selectedSeatIds = {};

  @override
  void initState() {
    super.initState();
    movie = MockData.getMovies().cast<Movie?>().firstWhere(
      (m) => m?.id == widget.movieId,
      orElse: () => null,
    );
    // Tạo bản copy của list ghế để thoải mái UI tương tác
    allSeats = MockData.getSeats().map((s) => s.copyWith()).toList();
  }

  void _toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.booked) return;

    // Phản hồi xúc giác (rung nhẹ) khi bấm
    HapticFeedback.selectionClick();

    setState(() {
      if (selectedSeatIds.contains(seat.id)) {
        selectedSeatIds.remove(seat.id);
      } else {
        // Giới hạn tối đa 8 ghế
        if (selectedSeatIds.length >= 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bạn chỉ được chọn tối đa 8 ghế cho mỗi giao dịch!'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        selectedSeatIds.add(seat.id);
      }
    });
  }

  double _calculateTotalPrice() {
    if (movie == null) return 0;
    double total = 0;
    for (String seatId in selectedSeatIds) {
      final seat = allSeats.firstWhere((s) => s.id == seatId);
      if (seat.type == SeatType.standard) {
        total += movie!.basePrice;
      } else if (seat.type == SeatType.vip) {
        total += movie!.basePrice + 20000;
      } else if (seat.type == SeatType.sweetbox) {
        total += (movie!.basePrice * 2) + 10000; // Phụ thu ghế đôi
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: const Center(child: Text('Không tìm thấy phim')),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(movie!.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Màn hình cong (Curved Screen)
          _buildScreenArc(),
          const SizedBox(height: 32),
          
          // 2. Sơ đồ ghế (Seat Grid)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildSeatRows(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 3. Legend (Chú thích)
          _buildLegend(),
          const SizedBox(height: 16),
        ],
      ),
      
      // 4. Bottom Checkout Bar
      bottomNavigationBar: _buildBottomBar(currencyFormat),
    );
  }

  Widget _buildScreenArc() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Ánh sáng hắt ra từ màn hình (Glow effect)
          Container(
            height: 30,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // Hình dáng màn hình cong
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width * 0.8, 60),
            painter: ScreenPainter(),
          ),
          const Positioned(
            bottom: 0,
            child: Text(
              'MÀN HÌNH',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSeatRows() {
    // Tách ghế theo hàng (row)
    Map<String, List<Seat>> rows = {};
    for (var seat in allSeats) {
      if (!rows.containsKey(seat.row)) {
        rows[seat.row] = [];
      }
      rows[seat.row]!.add(seat);
    }

    List<Widget> rowWidgets = [];
    rows.forEach((rowName, seatsInRow) {
      rowWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Nhãn tên hàng ghế (A, B, C...)
              SizedBox(
                width: 20,
                child: Text(
                  rowName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Các ghế trong hàng
              ...seatsInRow.map((seat) => _buildSeatWidget(seat)).toList(),
            ],
          ),
        ),
      );
    });

    return rowWidgets;
  }

  Widget _buildSeatWidget(Seat seat) {
    bool isSelected = selectedSeatIds.contains(seat.id);
    bool isBooked = seat.status == SeatStatus.booked;
    
    Color seatColor;
    Color borderColor;

    if (isBooked) {
      seatColor = Colors.grey.shade800;
      borderColor = Colors.grey.shade700;
    } else if (isSelected) {
      seatColor = AppColors.primary;
      borderColor = AppColors.primary;
    } else {
      // Ghế trống (Available)
      seatColor = AppColors.surface;
      if (seat.type == SeatType.vip) {
        borderColor = Colors.orange; // VIP màu viền cam
      } else if (seat.type == SeatType.sweetbox) {
        borderColor = Colors.pinkAccent; // Sweetbox màu hồng
      } else {
        borderColor = Colors.white54; // Thường màu trắng mờ
      }
    }

    // Ghế sweetbox thì rộng gấp đôi
    double width = seat.type == SeatType.sweetbox ? 70.0 : 32.0;

    return GestureDetector(
      onTap: () => _toggleSeat(seat),
      child: Container(
        margin: const EdgeInsets.only(right: 6.0),
        width: width,
        height: 32,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          seat.number.toString(),
          style: TextStyle(
            color: isBooked ? Colors.white30 : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          _legendItem(Colors.white54, 'Thường', false),
          _legendItem(Colors.orange, 'VIP', false),
          _legendItem(Colors.pinkAccent, 'Sweetbox', false),
          _legendItem(AppColors.primary, 'Đang chọn', true),
          _legendItem(Colors.grey.shade700, 'Đã đặt', true),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, bool isFilled) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isFilled ? color : AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBottomBar(NumberFormat format) {
    double totalPrice = _calculateTotalPrice();
    bool hasSelection = selectedSeatIds.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20.0).copyWith(bottom: 32.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24), // Màu tối hơn để tách biệt
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasSelection) ...[
                  Text(
                    'Ghế: ${(selectedSeatIds.toList()..sort()).join(', ')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ] else ...[
                  const Text(
                    'Chưa chọn ghế',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  format.format(totalPrice),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: hasSelection
                ? () {
                    // Điều hướng sang trang Thanh Toán
                    context.push(
                      '/checkout',
                      extra: {
                        'movieId': widget.movieId,
                        'seats': selectedSeatIds.toList()..sort(),
                        'totalPrice': totalPrice,
                      },
                    );
                  }
                : null, // Disable nếu chưa chọn ghế
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'TIẾP TỤC',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Vẽ đường cong giả lập màn hình chiếu phim
class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
