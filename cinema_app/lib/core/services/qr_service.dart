/// ============================================================
/// QR CODE SERVICE – Tạo mã QR offline từ dữ liệu vé
/// ============================================================
///
/// Quy trình:
///   1. Gộp các thông tin vé thành một JSON string có cấu trúc.
///   2. Thêm checksum (hash đơn giản) để phát hiện giả mạo.
///   3. Encode thành base64 URL-safe để QR code gọn hơn.
///   4. Widget QrImageView của qr_flutter sẽ render chuỗi này.
///
/// Decode (soát vé):
///   1. Quét QR → nhận chuỗi base64.
///   2. Decode base64 → JSON.
///   3. Kiểm tra checksum.
///   4. Xác thực ticketId trên Firestore.
/// ============================================================

import 'dart:convert';

class QrService {
  // ─────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────

  /// Tạo chuỗi QR data từ thông tin vé.
  ///
  /// Chuỗi này được truyền trực tiếp vào widget [QrImageView].
  ///
  /// [ticketId]   – ID vé duy nhất (document ID từ Firestore).
  /// [movieTitle] – Tên phim (để soát vé dễ đọc hơn).
  /// [showtimeId] – ID suất chiếu.
  /// [seats]      – Danh sách mã ghế (VD: ['A1', 'A2']).
  /// [uid]        – UID của người dùng đặt vé.
  static String generateQrData({
    required String ticketId,
    required String movieTitle,
    required String showtimeId,
    required List<String> seats,
    required String uid,
  }) {
    final payload = {
      'tid': ticketId,          // Ticket ID
      'mov': movieTitle,        // Movie title
      'shw': showtimeId,        // Showtime ID
      'sts': seats.join(','),   // Seats comma-separated
      'uid': uid,               // User ID
      'iat': DateTime.now().millisecondsSinceEpoch, // Issued at
      'chk': _generateChecksum(ticketId, uid, showtimeId), // Checksum
    };

    // Encode thành JSON rồi base64 URL-safe (không có padding) để gọn QR
    final jsonStr = jsonEncode(payload);
    return base64Url.encode(utf8.encode(jsonStr)).replaceAll('=', '');
  }

  /// Decode chuỗi QR data ngược lại thành Map.
  /// Trả về null nếu dữ liệu không hợp lệ hoặc checksum sai.
  static QrTicketPayload? decodeQrData(String qrString) {
    try {
      // Thêm lại padding nếu thiếu
      final padded = _addBase64Padding(qrString);
      final decoded = utf8.decode(base64Url.decode(padded));
      final Map<String, dynamic> payload = jsonDecode(decoded);

      // Kiểm tra checksum
      final expectedChk = _generateChecksum(
        payload['tid'] as String,
        payload['uid'] as String,
        payload['shw'] as String,
      );
      if (payload['chk'] != expectedChk) return null;

      return QrTicketPayload(
        ticketId:   payload['tid'] as String,
        movieTitle: payload['mov'] as String,
        showtimeId: payload['shw'] as String,
        seats:      (payload['sts'] as String).split(','),
        uid:        payload['uid'] as String,
        issuedAt:   DateTime.fromMillisecondsSinceEpoch(payload['iat'] as int),
      );
    } catch (_) {
      return null;
    }
  }

  /// Tạo ticket ID ngắn gọn dạng CT-XXXXXXX (7 ký tự hex).
  /// Dựa trên timestamp + uid để gần như không trùng lặp.
  static String generateTicketId({required String uid}) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    // XOR timestamp với hashCode của uid → 7 ký tự hex
    final hash = (ts ^ uid.hashCode).toRadixString(16).toUpperCase();
    final part = hash.length > 7 ? hash.substring(hash.length - 7) : hash.padLeft(7, '0');
    return 'CT-$part';
  }

  // ─────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────────

  /// Tạo checksum đơn giản: XOR của hashCode các field quan trọng → hex string
  static String _generateChecksum(
    String ticketId,
    String uid,
    String showtimeId,
  ) {
    final combined = '$ticketId|$uid|$showtimeId|CT220H_SECRET';
    final hash = combined.codeUnits.fold(0, (acc, c) => acc ^ c);
    return hash.toRadixString(16).padLeft(4, '0');
  }

  /// Thêm Base64 padding '=' bị thiếu
  static String _addBase64Padding(String s) {
    final mod = s.length % 4;
    if (mod == 0) return s;
    return s + '=' * (4 - mod);
  }
}

// ─────────────────────────────────────────────────────────────
// DATA CLASS
// ─────────────────────────────────────────────────────────────

/// Dữ liệu vé được decode từ QR code
class QrTicketPayload {
  final String ticketId;
  final String movieTitle;
  final String showtimeId;
  final List<String> seats;
  final String uid;
  final DateTime issuedAt;

  const QrTicketPayload({
    required this.ticketId,
    required this.movieTitle,
    required this.showtimeId,
    required this.seats,
    required this.uid,
    required this.issuedAt,
  });

  @override
  String toString() =>
      'QrTicketPayload(ticketId: $ticketId, movie: $movieTitle, seats: $seats)';
}
