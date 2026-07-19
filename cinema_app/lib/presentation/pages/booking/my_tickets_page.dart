import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text(
            'Vé của tôi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Sắp chiếu'),
              Tab(text: 'Đã xem'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UpcomingTicketsTab(),
            _PastTicketsTab(),
          ],
        ),
      ),
    );
  }
}

class _UpcomingTicketsTab extends StatelessWidget {
  const _UpcomingTicketsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTicketCard(
          context: context,
          movieTitle: 'Deadpool & Wolverine',
          date: 'Hôm nay, 14:30',
          cinema: 'Rạp 1 - CT220H Cinema',
          seats: 'G8, G9',
          imageUrl: 'https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg',
          isPast: false,
        ),
        const SizedBox(height: 16),
        _buildTicketCard(
          context: context,
          movieTitle: 'Mai',
          date: 'Ngày mai, 19:00',
          cinema: 'Rạp 3 - CT220H Cinema',
          seats: 'V10, V11',
          imageUrl: 'https://image.tmdb.org/t/p/w500/1XyBGEgjeGg1s6p4m0LpXyFk3bN.jpg',
          isPast: false,
        ),
      ],
    );
  }
}

class _PastTicketsTab extends StatelessWidget {
  const _PastTicketsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTicketCard(
          context: context,
          movieTitle: 'Spider-Man: No Way Home',
          date: '10/12/2023, 20:00',
          cinema: 'Rạp 2 - CT220H Cinema',
          seats: 'E4, E5',
          imageUrl: 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1R80vEM400kI1S.jpg',
          isPast: true,
        ),
      ],
    );
  }
}

Widget _buildTicketCard({
  required BuildContext context,
  required String movieTitle,
  required String date,
  required String cinema,
  required String seats,
  required String imageUrl,
  required bool isPast,
}) {
  return GestureDetector(
    onTap: () {
      // FIX: Route đúng là '/success', không phải '/payment_success'
      // Truyền mock data để tránh crash do GoRouter yêu cầu extra không được null
      context.push('/success', extra: {
        'movieId': 'm1', // Mock ID, trong thực tế cần lấy từ ticket data
        'seats': [seats],
        'totalPrice': 0.0,
      });
    },
    child: Opacity(
      opacity: isPast ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          boxShadow: isPast
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: ClipPath(
          clipper: TicketClipper(rightOffset: 110, holeRadius: 14),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: isPast
                  ? LinearGradient(
                      colors: [Colors.grey.shade900, Colors.grey.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isPast ? Colors.transparent : Colors.white12, width: 1),
            ),
            child: Row(
              children: [
                // === LEFT PART: Image + Info ===
                Expanded(
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: 100,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: double.infinity,
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.movie, color: Colors.white54),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Movie Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(date, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 14, color: Colors.white54),
                                  const SizedBox(width: 6),
                                  Text(cinema, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.chair_rounded, size: 14, color: Colors.white54),
                                  const SizedBox(width: 6),
                                  Text('Ghế: $seats', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // === DASHED DIVIDER ===
                CustomPaint(
                  size: const Size(2, 150),
                  painter: DashedLinePainter(),
                ),

                // === RIGHT PART: QR Stub ===
                SizedBox(
                  width: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.qr_code_2_rounded, color: Colors.black, size: 48),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isPast ? Colors.grey.shade800 : AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isPast ? Colors.transparent : AppColors.primary),
                        ),
                        child: Text(
                          isPast ? 'ĐÃ XEM' : 'QUÉT VÉ',
                          style: TextStyle(
                            color: isPast ? Colors.white54 : AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// === TICKET SHAPE CLIPPER ===
class TicketClipper extends CustomClipper<Path> {
  final double rightOffset;
  final double holeRadius;

  TicketClipper({required this.rightOffset, required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    final holePosition = size.width - rightOffset;

    path.lineTo(0, size.height); // Trái
    path.lineTo(holePosition - holeRadius, size.height); // Đáy tới lỗ
    path.arcToPoint(
      Offset(holePosition + holeRadius, size.height),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    ); // Lỗ đáy
    path.lineTo(size.width, size.height); // Đáy qua phải
    path.lineTo(size.width, 0); // Cạnh phải
    path.lineTo(holePosition + holeRadius, 0); // Đỉnh tới lỗ
    path.arcToPoint(
      Offset(holePosition - holeRadius, 0),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    ); // Lỗ đỉnh
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// === DASHED LINE PAINTER ===
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 6, dashSpace = 6, startY = 16;
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // Bắt đầu từ 16 và kết thúc cách đáy 16 để tránh lấn vào lỗ khuyết
    while (startY < size.height - 16) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
