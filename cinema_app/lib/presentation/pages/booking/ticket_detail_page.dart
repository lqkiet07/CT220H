import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/ticket.dart';
import '../../../data/models/movie.dart';
import '../../../data/mock/mock_data.dart';

class TicketDetailPage extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailPage({super.key, required this.ticket});

  String _formatShowtime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('HH:mm - dd/MM/yyyy').format(date);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = MockData.getMovies().firstWhere(
      (m) => m.id == ticket.movieId,
      orElse: () => const Movie(
        id: '',
        title: 'Phim không xác định',
        posterUrl: '',
        rating: 0,
        durationMinutes: 0,
        basePrice: 0,
        genres: [],
      ),
    );

    final seats = ticket.seatIds.join(', ');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết vé', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Vui lòng xuất trình mã QR này tại quầy soát vé',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // THẺ VÉ VÀ MÃ QR
                ClipPath(
                  clipper: SuccessTicketClipper(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // MÃ QR TẠO TỪ TICKET DATA
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: QrImageView(
                            data: ticket.qrCodeData,
                            version: QrVersions.auto,
                            size: 180.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          ticket.id,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Vạch phân cách
                        SizedBox(
                          height: 1,
                          child: Row(
                            children: List.generate(
                              30,
                              (index) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                  child: Container(color: Colors.white24, height: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // THÔNG TIN VÉ CHI TIẾT
                        _buildInfoRow('Phim', movie.title),
                        const SizedBox(height: 12),
                        _buildInfoRow('Rạp', 'CT220H Cinema'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Phòng', ticket.roomName),
                        const SizedBox(height: 12),
                        _buildInfoRow('Thời gian', _formatShowtime(ticket.startTime)),
                        const SizedBox(height: 12),
                        _buildInfoRow('Ghế', seats),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Tổng tiền',
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(ticket.totalPrice),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// SuccessTicketClipper được tái định nghĩa cục bộ để tránh lỗi import
class SuccessTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path();
    double radius = 15;
    double clipPosition = 330;

    holePath.addOval(Rect.fromCircle(center: Offset(size.width, clipPosition), radius: radius));
    holePath.addOval(Rect.fromCircle(center: Offset(0, clipPosition), radius: radius));

    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
