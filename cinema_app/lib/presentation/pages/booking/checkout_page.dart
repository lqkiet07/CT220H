import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/movie.dart';
import '../../../data/mock/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ticket_provider.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const CheckoutPage({super.key, required this.bookingData});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Movie movie;
  int _remainingSeconds = 300; // 5 phút đếm ngược
  Timer? _timer;
  String _selectedPaymentMethod = 'VNPAY';

  @override
  void initState() {
    super.initState();
    // Lấy phim từ mock data
    final movieId = widget.bookingData['movieId'];
    movie = MockData.getMovies().firstWhere((m) => m.id == movieId);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Hết thời gian giữ vé', style: TextStyle(color: Colors.white)),
        content: const Text('Thời gian giữ vé đã hết. Vui lòng đặt lại từ đầu.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Đóng dialog
              context.go('/'); // Về trang chủ
            },
            child: const Text('ĐỒNG Ý', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final seats = (widget.bookingData['seats'] as List<String>).join(', ');
    final totalPrice = widget.bookingData['totalPrice'] as double;
    
    // Tính phút và giây
    final minutes = (_remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final isWarningTime = _remainingSeconds < 60; // Dưới 1 phút thì cảnh báo đỏ

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thanh Toán', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ĐỒNG HỒ ĐẾM NGƯỢC
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isWarningTime ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isWarningTime ? Colors.red : Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, color: isWarningTime ? Colors.red : Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Thời gian giữ vé: $minutes:$seconds',
                    style: TextStyle(
                      color: isWarningTime ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // TICKET HÓA ĐƠN
            ClipPath(
              clipper: TicketClipper(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nửa trên của vé
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(movie.posterUrl, width: 80, height: 120, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                const Text('Rạp chiếu: CT220H Cinema', style: TextStyle(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text('Phòng chiếu: ${widget.bookingData['roomName'] ?? 'Phòng chiếu'}', style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text('Thời gian: ${_formatShowtime(widget.bookingData['startTime'])}', style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Đường kẻ đứt phân cách (Dashed line)
                    SizedBox(
                      height: 20,
                      child: Row(
                        children: List.generate(
                          30,
                          (index) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Container(color: Colors.white24, height: 1),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Nửa dưới của vé (Ghế và Tiền)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Ghế đã chọn', style: TextStyle(color: Colors.white54, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(seats, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Tổng thanh toán', style: TextStyle(color: Colors.white54, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormat.format(totalPrice),
                                style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // PHƯƠNG THỨC THANH TOÁN
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Phương thức thanh toán',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption('VNPAY', 'Cổng thanh toán VNPAY', Icons.qr_code_scanner),
            const SizedBox(height: 12),
            _buildPaymentOption('MoMo', 'Ví điện tử MoMo', Icons.account_balance_wallet),
            const SizedBox(height: 12),
            _buildPaymentOption('Card', 'Thẻ ATM / Visa / Mastercard', Icons.credit_card),
            
            const SizedBox(height: 40),
          ],
        ),
      ),

      // BOTTOM NAVBAR NÚT THANH TOÁN
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              // Hủy đồng hồ
              _timer?.cancel();
              
              final authProvider = context.read<AuthProvider>();
              final ticketProvider = context.read<TicketProvider>();

              final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_uid_for_testing';
              
              if (!authProvider.isLoggedIn && FirebaseAuth.instance.currentUser == null) {
                SnackbarUtils.showError(context, 'Bạn cần đăng nhập để đặt vé!');
                return;
              }

              // Hiện Loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );

              final showtimeId = widget.bookingData['showtimeId'] as String? ?? '';
              final totalPrice = (widget.bookingData['totalPrice'] as num).toDouble();

              // Gọi API đặt vé qua provider (trong ruột là runTransaction)
              final bool success = await ticketProvider.bookTicket(
                showtimeId: showtimeId,
                userId: uid,
                totalPrice: totalPrice,
              );

              if (!context.mounted) return;
              
              // Đóng dialog loading
              Navigator.of(context).pop();

              if (success) {
                // Truyền thêm uid vào bookingData để QrService dùng
                final extraData = Map<String, dynamic>.from(widget.bookingData);
                extraData['uid'] = uid;
                context.push('/success', extra: extraData);
              } else {
                SnackbarUtils.showError(context, ticketProvider.errorMessage ?? 'Đặt vé thất bại');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              shadowColor: AppColors.primary.withOpacity(0.5),
              elevation: 10,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'THANH TOÁN NGAY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String id, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.white54, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// Lớp vẽ viền cắt răng cưa (Khoét lỗ 2 bên) cho vé
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Tạo khung hình chữ nhật ban đầu của tấm vé
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path();
    // Bán kính của lỗ khoét
    double radius = 15;
    // Vị trí của lỗ khoét (Ngay tại vạch kẻ đứt)
    double clipPosition = 160;

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
