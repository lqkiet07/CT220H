/// ============================================================
/// DYNAMIC PRICING ENGINE – Smart Ticket Pricing
/// ============================================================
///
/// Công thức tính giá:
///
///   finalPrice = basePrice × seatMultiplier × timeMultiplier × dayMultiplier
///
/// Trong đó:
///   basePrice       – Giá gốc của phim (từ Movie.basePrice)
///   seatMultiplier  – Hệ số loại ghế (Standard=1.0, VIP=1.3, Sweetbox=1.8)
///   timeMultiplier  – Hệ số theo giờ chiếu
///   dayMultiplier   – Hệ số theo ngày trong tuần
///
/// Bảng timeMultiplier:
///   00:00 – 10:59  → "Sáng sớm"    × 0.8  (giảm 20%)
///   11:00 – 13:59  → "Trưa"        × 0.9  (giảm 10%)
///   14:00 – 17:59  → "Chiều"       × 1.0  (giá gốc)
///   18:00 – 21:59  → "Tối cao điểm"× 1.2  (tăng 20%)
///   22:00 – 23:59  → "Khuya"       × 1.1  (tăng 10%)
///
/// Bảng dayMultiplier:
///   Thứ 2 – Thứ 5  → × 1.0  (ngày thường)
///   Thứ 6          → × 1.1  (cuối tuần sắp đến)
///   Thứ 7 – CN     → × 1.25 (cuối tuần)
///   Ngày lễ quốc gia → × 1.4 (lễ - hardcoded một số ngày quan trọng)
///
/// ============================================================

import '../../data/models/seat.dart';

class PricingEngine {
  // ─────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────

  /// Tính giá vé cuối cùng cho một ghế cụ thể.
  ///
  /// [basePrice]  – Giá cơ bản của phim (VNĐ).
  /// [seatType]   – Loại ghế (standard / vip / sweetbox).
  /// [showTime]   – Thời điểm bắt đầu suất chiếu.
  static PriceBreakdown calculate({
    required double basePrice,
    required SeatType seatType,
    required DateTime showTime,
  }) {
    final double seatMult = _seatMultiplier(seatType);
    final double timeMult = _timeMultiplier(showTime.hour);
    final double dayMult  = _dayMultiplier(showTime);

    final double finalPrice = basePrice * seatMult * timeMult * dayMult;

    return PriceBreakdown(
      basePrice:        basePrice,
      seatMultiplier:   seatMult,
      timeMultiplier:   timeMult,
      dayMultiplier:    dayMult,
      finalPrice:       _roundPrice(finalPrice),
      seatTypeName:     _seatTypeName(seatType),
      timeSlotName:     _timeSlotName(showTime.hour),
      dayTypeName:      _dayTypeName(showTime),
    );
  }

  /// Tính tổng giá cho nhiều ghế khác nhau cùng lúc.
  ///
  /// [seats]     – Danh sách (seatType, count) cần tính.
  /// [basePrice] – Giá gốc phim.
  /// [showTime]  – Giờ chiếu.
  static TotalPriceResult calculateTotal({
    required List<SeatType> seatTypes,
    required double basePrice,
    required DateTime showTime,
  }) {
    final List<PriceBreakdown> breakdowns = seatTypes
        .map((type) => calculate(
              basePrice: basePrice,
              seatType:  type,
              showTime:  showTime,
            ))
        .toList();

    final double total =
        breakdowns.fold(0.0, (sum, item) => sum + item.finalPrice);

    return TotalPriceResult(
      breakdowns: breakdowns,
      totalPrice: _roundPrice(total),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // MULTIPLIER TABLES
  // ─────────────────────────────────────────────────────────────

  /// Hệ số theo loại ghế
  static double _seatMultiplier(SeatType type) {
    switch (type) {
      case SeatType.standard: return 1.0;
      case SeatType.vip:      return 1.3;
      case SeatType.sweetbox: return 1.8;
    }
  }

  /// Hệ số theo giờ chiếu (0–23)
  static double _timeMultiplier(int hour) {
    if (hour >= 0  && hour < 11) return 0.80; // Sáng sớm
    if (hour >= 11 && hour < 14) return 0.90; // Buổi trưa
    if (hour >= 14 && hour < 18) return 1.00; // Chiều (giá cơ bản)
    if (hour >= 18 && hour < 22) return 1.20; // Tối cao điểm
    return 1.10;                               // Khuya (22:00+)
  }

  /// Hệ số theo ngày trong tuần + ngày lễ
  static double _dayMultiplier(DateTime date) {
    // Kiểm tra ngày lễ quốc gia trước
    if (_isNationalHoliday(date)) return 1.40;

    // Ngày cuối tuần
    final int weekday = date.weekday; // 1=T2, 6=T6, 7=T7, 7=CN→dart: 7
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return 1.25;
    }
    if (weekday == DateTime.friday) return 1.10;
    return 1.00; // Thứ 2 đến Thứ 5
  }

  /// Danh sách ngày lễ quốc gia Việt Nam (MM-DD format)
  static bool _isNationalHoliday(DateTime date) {
    final String mmdd = '${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';

    const holidays = {
      '01-01', // Tết Dương lịch
      '04-30', // Giải phóng miền Nam
      '05-01', // Quốc tế Lao động
      '09-02', // Quốc khánh
      '01-27', // Giỗ Tổ Hùng Vương (27/3 âm lịch – tạm hardcode DL)
    };

    return holidays.contains(mmdd);
  }

  // ─────────────────────────────────────────────────────────────
  // NAME HELPERS (cho UI)
  // ─────────────────────────────────────────────────────────────

  static String _seatTypeName(SeatType type) {
    switch (type) {
      case SeatType.standard: return 'Ghế Thường';
      case SeatType.vip:      return 'Ghế VIP';
      case SeatType.sweetbox: return 'Ghế Sweetbox';
    }
  }

  static String _timeSlotName(int hour) {
    if (hour >= 0  && hour < 11) return 'Sáng sớm (giảm 20%)';
    if (hour >= 11 && hour < 14) return 'Buổi trưa (giảm 10%)';
    if (hour >= 14 && hour < 18) return 'Buổi chiều';
    if (hour >= 18 && hour < 22) return 'Tối cao điểm (+20%)';
    return 'Suất khuya (+10%)';
  }

  static String _dayTypeName(DateTime date) {
    if (_isNationalHoliday(date)) return 'Ngày lễ (+40%)';
    final int weekday = date.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return 'Cuối tuần (+25%)';
    }
    if (weekday == DateTime.friday) return 'Thứ Sáu (+10%)';
    return 'Ngày thường';
  }

  /// Làm tròn giá đến 1.000 VNĐ gần nhất (user-friendly)
  static double _roundPrice(double price) {
    return (price / 1000).round() * 1000.0;
  }
}

// ─────────────────────────────────────────────────────────────
// DATA CLASSES
// ─────────────────────────────────────────────────────────────

/// Chi tiết bảng tính giá cho 1 ghế
class PriceBreakdown {
  final double basePrice;
  final double seatMultiplier;
  final double timeMultiplier;
  final double dayMultiplier;
  final double finalPrice;
  final String seatTypeName;
  final String timeSlotName;
  final String dayTypeName;

  const PriceBreakdown({
    required this.basePrice,
    required this.seatMultiplier,
    required this.timeMultiplier,
    required this.dayMultiplier,
    required this.finalPrice,
    required this.seatTypeName,
    required this.timeSlotName,
    required this.dayTypeName,
  });

  /// Tổng hệ số (để hiển thị nhanh trên UI)
  double get combinedMultiplier => seatMultiplier * timeMultiplier * dayMultiplier;

  @override
  String toString() =>
      'PriceBreakdown($seatTypeName: ${finalPrice.toStringAsFixed(0)}đ '
      '[seat×$seatMultiplier, time×$timeMultiplier, day×$dayMultiplier])';
}

/// Kết quả tính giá tổng cho nhiều ghế
class TotalPriceResult {
  final List<PriceBreakdown> breakdowns;
  final double totalPrice;

  const TotalPriceResult({
    required this.breakdowns,
    required this.totalPrice,
  });
}
