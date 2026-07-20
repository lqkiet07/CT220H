import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/ticket.dart';
import '../../../data/mock/mock_data.dart';
import '../../providers/booking_provider.dart';

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
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
    final tickets = context.watch<BookingProvider>().upcomingTickets;

    if (tickets.isEmpty) {
      return const _EmptyTicketsState(
        message: 'Không có vé sắp chiếu nào.',
        subMessage: 'Hãy chọn bộ phim yêu thích của bạn và đặt vé ngay nhé!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final movie = MockData.getMovies().firstWhere(
          (m) => m.id == ticket.movieId,
          orElse: () => const Movie(id: '', title: 'Phim không xác định', posterUrl: '', rating: 0, durationMinutes: 0, basePrice: 0, genres: []),
        );

        String displayDate = '';
        try {
          final date = DateTime.parse(ticket.startTime);
          displayDate = DateFormat('HH:mm - dd/MM/yyyy').format(date);
        } catch (e) {
          displayDate = ticket.startTime;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildTicketCard(
            context: context,
            ticket: ticket,
            movieTitle: movie.title,
            date: displayDate,
            cinema: 'CT220H Cinema - ${ticket.roomName}',
            seats: ticket.seatIds.join(', '),
            imageUrl: movie.posterUrl,
            isPast: false,
          ),
        );
      },
    );
  }
}

class _PastTicketsTab extends StatelessWidget {
  const _PastTicketsTab();

  @override
  Widget build(BuildContext context) {
    final tickets = context.watch<BookingProvider>().pastTickets;

    if (tickets.isEmpty) {
      return const _EmptyTicketsState(
        message: 'Lịch sử xem phim trống.',
        subMessage: 'Bạn chưa xem bộ phim nào gần đây.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final movie = MockData.getMovies().firstWhere(
          (m) => m.id == ticket.movieId,
          orElse: () => const Movie(id: '', title: 'Phim không xác định', posterUrl: '', rating: 0, durationMinutes: 0, basePrice: 0, genres: []),
        );

        String displayDate = '';
        try {
          final date = DateTime.parse(ticket.startTime);
          displayDate = DateFormat('HH:mm - dd/MM/yyyy').format(date);
        } catch (e) {
          displayDate = ticket.startTime;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildTicketCard(
            context: context,
            ticket: ticket,
            movieTitle: movie.title,
            date: displayDate,
            cinema: 'CT220H Cinema - ${ticket.roomName}',
            seats: ticket.seatIds.join(', '),
            imageUrl: movie.posterUrl,
            isPast: true,
          ),
        );
      },
    );
  }
}

class _EmptyTicketsState extends StatelessWidget {
  final String message;
  final String subMessage;

  const _EmptyTicketsState({
    required this.message,
    required this.subMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.confirmation_num_outlined,
                size: 80,
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTicketCard({
  required BuildContext context,
  required Ticket ticket,
  required String movieTitle,
  required String date,
  required String cinema,
  required String seats,
  required String imageUrl,
  required bool isPast,
}) {
  return GestureDetector(
    onTap: () {
      context.push('/ticket_detail', extra: ticket);
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
                                  Expanded(
                                    child: Text(
                                      date,
                                      style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 14, color: Colors.white54),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      cinema,
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.chair_rounded, size: 14, color: Colors.white54),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Ghế: $seats',
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
