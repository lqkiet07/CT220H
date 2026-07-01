import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const CinemaApp());
}

class CinemaApp extends StatelessWidget {
  const CinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // TODO: Thêm các Provider (ChangeNotifier) của Thành viên A vào đây ở Giai đoạn 2
        // Ví dụ: ChangeNotifierProvider(create: (_) => CartProvider()),
        
        // Cung cấp 1 Provider tạm thời để MultiProvider không bị lỗi mảng rỗng
        Provider<String>(create: (_) => "Init"), 
      ],
      child: MaterialApp.router(
        title: 'Cinema App CT220H',
        theme: AppTheme.darkTheme, // Kích hoạt Dark Theme toàn cục
        routerConfig: AppRouter.router, // Bật hệ thống điều hướng Go Router
        debugShowCheckedModeBanner: false, // Ẩn chữ DEBUG góc phải
      ),
    );
  }
}
