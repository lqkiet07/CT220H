import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/qr_service.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/ticket.dart';
import '../../../data/mock/mock_data.dart';
import '../../providers/booking_provider.dart';

class PaymentSuccessPage extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const PaymentSuccessPage({super.key, required this.bookingData});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> with SingleTickerProviderStateMixin {
  late Movie movie;
  late String ticketId;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  late String _qrData;

  @override
  void initState() {
    super.initState();
    final movieId = widget.bookingData['movieId'] as String? ?? '';
    movie = MockData.getMovies().firstWhere(
      (m) => m.id == movieId,
      orElse: () => MockData.getMovies().first,
    );

    // FIX: Dùng QrService tạo ticketId có cấu trúc CT-XXXXXXX
    final uid = widget.bookingData['uid'] as String? ?? 'guest';
    ticketId = QrService.generateTicketId(uid: uid);

    // Tạo chuỗi QR đầy đủ thông tin vé (có checksum)
    final seats = (widget.bookingData['seats'] as List?)?.cast<String>() ?? [];
    final showtimeId = widget.bookingData['showtimeId'] as String? ?? 'N/A';
    _qrData = QrService.generateQrData(
      ticketId:   ticketId,
      movieTitle: movie.title,
      showtimeId: showtimeId,
      seats:      seats,
      uid:        uid,
    );

    // Hiệu ứng pop-up cho mã QR
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    
    _animationController.forward();

    // Only save ticket if this is a fresh payment (not a re-view from My Tickets)
    final isNewBooking = widget.bookingData['isNewBooking'] as bool? ?? true;
    if (isNewBooking) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ticket = Ticket(
          id: ticketId,
          movieId: widget.bookingData['movieId'] ?? '',
          showtimeId: widget.bookingData['showtimeId'] ?? '',
          roomName: widget.bookingData['roomName'] ?? '',
          startTime: widget.bookingData['startTime'] ?? '',
          seatIds: (widget.bookingData['seats'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          totalPrice: widget.bookingData['totalPrice'] as double? ?? 0.0,
          bookingTime: DateTime.now(),
          qrCodeData: ticketId,
        );
        context.read<BookingProvider>().addTicket(ticket);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seats = (widget.bookingData['seats'] as List<String>).join(', ');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Icon Thành Công
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Thanh toán thành công!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dưới đây là mã vé điện tử của bạn',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 32),

                // THẺ VÉ VÀ MÃ QR
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ClipPath(
                    clipper: SuccessTicketClipper(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        // Bỏ shadow đi vì ClipPath sẽ cắt mất bóng ngoài viền
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // MÃ QR ĐƯỢC TẠO TỰ ĐỘNG
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: GestureDetector(
                              // Giữ QR để copy data (tiện cho debugging)
                              onLongPress: () {
                                Clipboard.setData(ClipboardData(text: ticketId));
                              },
                              child: QrImageView(
                                // FIX: Dùng _qrData chứa đầy đủ thông tin vé
                                data: _qrData,
                                version: QrVersions.auto,
                                size: 180.0,
                                backgroundColor: Colors.white,
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            ticketId,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Đường kẻ đứt phân cách (Dashed line) thay cho Divider trơn
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
                        
                        // THÔNG TIN VÉ
                        _buildInfoRow('Phim', movie.title),
                        const SizedBox(height: 12),
                        _buildInfoRow('Rạp', 'CT220H Cinema'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Phòng', widget.bookingData['roomName'] ?? 'Phòng chiếu'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Thời gian', _formatShowtime(widget.bookingData['startTime'])),
                        const SizedBox(height: 12),
                        _buildInfoRow('Ghế', seats),
                      ],
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 32),

                // BUTTONS: 2 nút nằm ngang cạnh nhau
                Row(
                  children: [
                    // NÚT VỀ TRANG CHỦ
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'TRANG CHỦ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // NÚT XEM VÉ CỦA TÔI
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go('/my_tickets'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'VÉ CỦA TÔI',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatShowtime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('HH:mm - dd/MM').format(date);
    } catch (e) {
      return isoString;
    }
  }
}

// Lớp vẽ viền cắt răng cưa (Khoét lỗ 2 bên) cho vé QR
class SuccessTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Tạo khung hình chữ nhật ban đầu của tấm vé
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path();
    // Bán kính của lỗ khoét
    double radius = 15;
    // Vị trí lỗ khoét (Ngay tại vạch kẻ đứt - Tọa độ Y khoảng 320 cho layout này)
    double clipPosition = 330;

    // Lỗ bên phải
    holePath.addOval(Rect.fromCircle(center: Offset(size.width, clipPosition), radius: radius));
    // Lỗ bên trái
    holePath.addOval(Rect.fromCircle(center: Offset(0, clipPosition), radius: radius));

    // Cắt hai cái lỗ ra khỏi hình chữ nhật
    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
