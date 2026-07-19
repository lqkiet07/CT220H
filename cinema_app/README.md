# 🎬 Cinema Booking App (CT220H)

Ứng dụng đặt vé xem phim rạp chất lượng cao được xây dựng bằng **Flutter** và **Firebase**, áp dụng kiến trúc **Clean Architecture**. Dự án cung cấp giải pháp toàn diện cho cả khách hàng (đặt vé, chọn ghế, lịch sử) và quản trị viên (quản lý phim, suất chiếu).

---

## 🌟 Tính năng nổi bật

### Dành cho Khách Hàng
*   **🎭 Khám phá Phim:** Xem danh sách phim đang chiếu, sắp chiếu, xu hướng với thông tin chi tiết (trailer, đánh giá, thời lượng).
*   **📅 Chọn Suất Chiếu & Rạp:** Lọc suất chiếu theo ngày và rạp với UI trực quan.
*   **💺 Thuật toán Đặt Ghế Thông Minh:**
    *   Hỗ trợ tự động chọn ghế VIP/trung tâm nhất dựa trên khoảng cách Euclidean.
    *   Thuật toán "Sliding Window" đảm bảo chọn các ghế nằm cạnh nhau.
*   **💰 Dynamic Pricing (Giá Động):** Thuật toán tự động tính toán giá vé dựa trên Hệ số thời gian (giờ cao điểm), Hệ số ngày (cuối tuần, lễ) và Loại ghế.
*   **🎟️ Vé Điện Tử (QR Code):** 
    *   Sinh mã QR offline với payload JSON thu gọn + Base64 Encoding.
    *   Tích hợp Checksum (XOR Hashing) để chống giả mạo vé.
*   **💳 Thanh toán:** Tích hợp giao diện mock (VNPAY, MoMo, Thẻ tín dụng) đảm bảo luồng UX hoàn chỉnh.

### Dành cho Quản Trị Viên (Admin)
*   **📊 Dashboard:** Xem thống kê doanh thu cơ bản.
*   **🎞️ Quản lý Phim (CRUD):** Thêm, sửa, xóa phim dễ dàng.
*   **🕒 Quản lý Suất Chiếu:** Lên lịch chiếu, chọn phòng, và điều chỉnh **Hệ số giá vé (Pricing Factor)** cho từng suất chiếu.
*   **🔒 Transaction An Toàn:** Sử dụng `runTransaction` của Firestore để khóa ghế khi thanh toán, đảm bảo **100% không bị trùng ghế** (Race Condition).

---

## 🏗️ Kiến trúc & Công nghệ

*   **Framework:** Flutter (Dart)
*   **Kiến trúc:** Clean Architecture (Domain, Data, Presentation)
*   **State Management:** Provider
*   **Routing:** GoRouter
*   **Backend / Database:** Firebase (Authentication, Cloud Firestore)
*   **UI/UX:** Custom Theme, Glassmorphism, Animations.

---

## 🚀 Hướng dẫn Cài đặt & Chạy dự án

### 1. Yêu cầu hệ thống
*   Flutter SDK (phiên bản >= 3.19.x)
*   Dart SDK
*   Android Studio / VS Code

### 2. Thiết lập Firebase (QUAN TRỌNG)
Dự án sử dụng Firebase làm backend. Bạn **BẮT BUỘC** phải cung cấp file cấu hình Firebase của riêng bạn để ứng dụng hoạt động.

**Đối với Android:**
1. Tạo một dự án trên [Firebase Console](https://console.firebase.google.com/).
2. Đăng ký ứng dụng Android với Package Name tương ứng (vd: `com.example.cinema_app`).
3. Tải file `google-services.json`.
4. Copy file này vào thư mục: `android/app/google-services.json`.

**Đối với iOS:**
1. Đăng ký ứng dụng iOS trên Firebase.
2. Tải file `GoogleService-Info.plist`.
3. Mở Xcode và kéo file này vào thư mục Runner.

**Cấu hình Database:**
1. Bật **Authentication** (Email/Password).
2. Bật **Cloud Firestore**.
3. (Tùy chọn) Có thể sử dụng `mock_data.dart` để tự động khởi tạo dữ liệu giả trong lần chạy đầu tiên nếu database rỗng.

### 3. Cài đặt thư viện
Mở terminal tại thư mục gốc của dự án và chạy:
```bash
flutter pub get
```

### 4. Build Runner (Cho các file Generate tự động)
Dự án sử dụng `json_serializable`. Chạy lệnh sau để tạo các file `.g.dart`:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Chạy ứng dụng
```bash
flutter run
```

---

## 📂 Cấu trúc thư mục (Clean Architecture)

```text
lib/
 ├── core/              # Chứa các file dùng chung (Algorithms, Services, Theme, Router)
 │    ├── algorithms/   # Chứa thuật toán (Pricing, Recommendation, Seat Selector)
 │    └── services/     # Chứa QrService,...
 ├── data/              # Chứa Models và Repositories Implementation (kết nối Firestore)
 ├── domain/            # Chứa Repositories Interfaces
 └── presentation/      # Chứa UI (Pages, Widgets) và State (Providers)
```

---

## 👨‍💻 Tác giả
*Dự án Môn học CT220H (Lập trình Di động Đa Nền Tảng).*
