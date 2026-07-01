import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_app/main.dart';

void main() {
  testWidgets('App khởi động thành công và hiển thị Home Page tạm', (WidgetTester tester) async {
    // Chạy thử ứng dụng
    await tester.pumpWidget(const CinemaApp());
    await tester.pumpAndSettle();

    // Kiểm tra xem chữ "Home Page" có xuất hiện không
    expect(find.textContaining('Home Page'), findsOneWidget);
  });
}
