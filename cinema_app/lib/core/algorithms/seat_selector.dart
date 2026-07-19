/// ============================================================
/// SMART SEAT SELECTOR – 2D Array Center-First Algorithm
/// ============================================================
///
/// Thuật toán: Biểu diễn phòng chiếu như mảng 2 chiều [row][col].
/// Tìm N ghế trống sao cho ghế đó gần trung tâm nhất.
///
/// Khoảng cách dùng: Euclidean Distance
///   d = √((r - centerR)² + (c - centerC)²)
///
/// Ưu tiên thứ tự:
///   1. Khoảng cách Euclidean đến trung tâm nhỏ nhất
///   2. Nếu bằng nhau: ưu tiên ghế giữa màn hình hơn (cột trung tâm)
///
/// Độ phức tạp: O(R × C × log(R×C)) – R: số hàng, C: số cột
/// ============================================================

import '../../data/models/seat.dart';
import 'dart:math' as math;

class SeatSelector {
  // ─────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────

  /// Tự động chọn [count] ghế trống tốt nhất (gần trung tâm màn hình nhất).
  ///
  /// [allSeats]  – Danh sách tất cả ghế trong phòng chiếu.
  /// [count]     – Số ghế muốn chọn (mặc định: 2).
  /// [preferred] – Loại ghế ưu tiên (null = không giới hạn).
  ///
  /// Trả về danh sách ghế được chọn (sorted từ trái qua phải).
  static SeatSelectionResult selectBestSeats({
    required List<Seat> allSeats,
    int count = 2,
    SeatType? preferred,
  }) {
    // ── BƯỚC 1: Xây dựng mảng 2D ──────────────────────────────
    final grid = _buildGrid(allSeats);
    if (grid.isEmpty) {
      return SeatSelectionResult(
        seats: [],
        reason: 'Không có dữ liệu ghế',
      );
    }

    final int totalRows = grid.length;
    final int totalCols = grid.values.map((r) => r.length).reduce(math.max);

    // Trọng tâm của phòng chiếu (tọa độ float)
    final double centerRow = (totalRows - 1) / 2.0;
    final double centerCol = (totalCols - 1) / 2.0;

    // ── BƯỚC 2: Lấy danh sách ghế trống + tính khoảng cách ───
    final List<_SeatCandidate> candidates = [];
    int rowIndex = 0;

    for (final rowName in grid.keys) {
      final seatsInRow = grid[rowName]!;

      for (int colIndex = 0; colIndex < seatsInRow.length; colIndex++) {
        final seat = seatsInRow[colIndex];

        // Chỉ xét ghế còn trống
        if (seat.status != SeatStatus.available) continue;

        // Lọc theo loại ghế ưu tiên nếu có
        if (preferred != null && seat.type != preferred) continue;

        final double dist = _euclideanDistance(
          rowIndex.toDouble(),
          colIndex.toDouble(),
          centerRow,
          centerCol,
        );

        candidates.add(_SeatCandidate(
          seat: seat,
          rowIndex: rowIndex,
          colIndex: colIndex,
          distanceToCenter: dist,
        ));
      }
      rowIndex++;
    }

    if (candidates.isEmpty) {
      final noTypeMsg = preferred != null
          ? 'Không còn ghế ${_seatTypeName(preferred)} trống'
          : 'Phòng chiếu đã hết ghế';
      return SeatSelectionResult(seats: [], reason: noTypeMsg);
    }

    // ── BƯỚC 3: Sắp xếp theo khoảng cách tăng dần ───────────
    candidates.sort((a, b) {
      final distCmp = a.distanceToCenter.compareTo(b.distanceToCenter);
      if (distCmp != 0) return distCmp;
      // Tie-break: cột gần trung tâm hơn
      return (a.colIndex - centerCol)
          .abs()
          .compareTo((b.colIndex - centerCol).abs());
    });

    // ── BƯỚC 4: Chọn ghế liên tiếp nếu count > 1 ────────────
    List<Seat> selected;

    if (count == 1) {
      selected = [candidates.first.seat];
    } else {
      selected = _selectConsecutiveSeats(candidates, grid, count);

      // Fallback: nếu không tìm được ghế liên tiếp, lấy N ghế gần nhất bất kỳ
      if (selected.isEmpty) {
        selected = candidates.take(count).map((c) => c.seat).toList();
      }
    }

    // Sắp xếp từ trái qua phải theo vị trí thực
    selected.sort((a, b) {
      final rowCmp = a.row.compareTo(b.row);
      if (rowCmp != 0) return rowCmp;
      return a.number.compareTo(b.number);
    });

    final seatNames = selected.map((s) => '${s.row}${s.number}').join(', ');
    return SeatSelectionResult(
      seats: selected,
      reason: 'Đề xuất ghế tốt nhất: $seatNames',
    );
  }

  /// Tính giá vé thực tế của một ghế dựa trên loại ghế.
  /// (Dùng kết hợp với PricingEngine để tính giá cuối.)
  static double seatTypeMultiplier(SeatType type) {
    switch (type) {
      case SeatType.standard:
        return 1.0;
      case SeatType.vip:
        return 1.3; // VIP +30%
      case SeatType.sweetbox:
        return 1.8; // Sweetbox +80% (ghế đôi)
    }
  }

  // ─────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────

  /// Xây dựng mảng 2D: Map<rowName, List<Seat>>
  /// Đảm bảo thứ tự hàng và ghế đúng.
  static Map<String, List<Seat>> _buildGrid(List<Seat> seats) {
    final Map<String, List<Seat>> grid = {};

    for (final seat in seats) {
      grid.putIfAbsent(seat.row, () => []);
      grid[seat.row]!.add(seat);
    }

    // Sắp xếp ghế trong từng hàng theo số ghế tăng dần
    for (final row in grid.values) {
      row.sort((a, b) => a.number.compareTo(b.number));
    }

    // Sắp xếp Map theo thứ tự bảng chữ cái của tên hàng (A, B, C...)
    final sorted = Map.fromEntries(
      grid.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return sorted;
  }

  /// Khoảng cách Euclidean giữa 2 điểm trong lưới 2D
  static double _euclideanDistance(
    double r1, double c1, double r2, double c2,
  ) {
    return math.sqrt(math.pow(r1 - r2, 2) + math.pow(c1 - c2, 2));
  }

  /// Tìm nhóm [count] ghế liên tiếp cùng hàng, gần trung tâm nhất.
  /// Thuật toán sliding window theo từng hàng.
  static List<Seat> _selectConsecutiveSeats(
    List<_SeatCandidate> candidates,
    Map<String, List<Seat>> grid,
    int count,
  ) {
    // Nhóm candidates theo hàng
    final Map<int, List<_SeatCandidate>> byRow = {};
    for (final c in candidates) {
      byRow.putIfAbsent(c.rowIndex, () => []);
      byRow[c.rowIndex]!.add(c);
    }

    // Kết quả tốt nhất: khoảng cách trung bình đến trung tâm nhỏ nhất
    List<Seat> best = [];
    double bestAvgDist = double.infinity;

    for (final rowCandidates in byRow.values) {
      // Sắp xếp trong hàng theo cột (để tìm ghế kề nhau)
      rowCandidates.sort((a, b) => a.colIndex.compareTo(b.colIndex));

      // Sliding window: tìm [count] ghế liên tiếp thực sự
      for (int i = 0; i <= rowCandidates.length - count; i++) {
        final window = rowCandidates.sublist(i, i + count);

        // Kiểm tra ghế có thực sự liền kề nhau không (colIndex liên tục)
        bool isConsecutive = true;
        for (int j = 1; j < window.length; j++) {
          if (window[j].colIndex != window[j - 1].colIndex + 1) {
            isConsecutive = false;
            break;
          }
        }

        if (!isConsecutive) continue;

        // Tính khoảng cách trung bình của nhóm ghế này
        final double avgDist = window
                .map((c) => c.distanceToCenter)
                .reduce((a, b) => a + b) /
            window.length;

        if (avgDist < bestAvgDist) {
          bestAvgDist = avgDist;
          best = window.map((c) => c.seat).toList();
        }
      }
    }

    return best;
  }

  static String _seatTypeName(SeatType type) {
    switch (type) {
      case SeatType.standard:
        return 'thường';
      case SeatType.vip:
        return 'VIP';
      case SeatType.sweetbox:
        return 'Sweetbox';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// DATA CLASSES
// ─────────────────────────────────────────────────────────────

/// Kết quả chọn ghế tự động
class SeatSelectionResult {
  /// Danh sách ghế được chọn (đã sắp theo vị trí)
  final List<Seat> seats;

  /// Thông báo lý do / mô tả kết quả
  final String reason;

  const SeatSelectionResult({required this.seats, required this.reason});

  bool get isSuccess => seats.isNotEmpty;
}

/// Lưu trữ tạm thông tin ứng viên ghế trong quá trình tính toán
class _SeatCandidate {
  final Seat seat;
  final int rowIndex;
  final int colIndex;
  final double distanceToCenter;

  const _SeatCandidate({
    required this.seat,
    required this.rowIndex,
    required this.colIndex,
    required this.distanceToCenter,
  });
}
