import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';


part 'database.g.dart';



// Bảng 1: Lưu vé đã đặt (Để người dùng xem offline lúc ra rạp)
@DataClassName('Ticket')
class Tickets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get movieId => text()();
  TextColumn get bookingTime => text()(); // Thời gian đặt
  TextColumn get qrCodeData => text()();  // Dữ liệu mã QR
  TextColumn get seatIds => text()();     // Danh sách ID ghế
  RealColumn get totalPrice => real()();  // Tổng tiền (kiểu double)
}

// Bảng 2: Phim yêu thích (Lưu lại danh sách phim muốn xem)
@DataClassName('FavoriteMovie')
class FavoriteMovies extends Table {
  TextColumn get movieId => text()();
  TextColumn get title => text()();
  TextColumn get posterUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {movieId}; // Đặt ID phim làm khóa chính
}

// --- CẤU HÌNH DATABASE ---

// 2. Khai báo các bảng vừa tạo vào Database
@DriftDatabase(tables: [Tickets, FavoriteMovies])
class AppDatabase extends _$AppDatabase {

  // Khởi tạo kết nối với file SQLite trên điện thoại
  AppDatabase() : super(_openConnection());

  // Phiên bản database (Sau này nếu thêm bảng mới thì tăng số này lên 2, 3...)
  @override
  int get schemaVersion => 1;

  // --- CÁC HÀM THAO TÁC DỮ LIỆU (CRUD) ---

  // Lấy danh sách tất cả vé đã lưu
  Future<List<Ticket>> getAllTickets() => select(tickets).get();

  // Thêm một vé mới vào máy
  Future<int> insertTicket(TicketsCompanion ticket) => into(tickets).insert(ticket);

  // Lấy danh sách phim yêu thích
  Future<List<FavoriteMovie>> getFavorites() => select(favoriteMovies).get();

  // Thêm phim vào danh sách yêu thích
  Future<int> addFavorite(FavoriteMoviesCompanion movie) => into(favoriteMovies).insert(movie);

  // Xóa phim khỏi danh sách yêu thích
  Future<int> removeFavorite(String id) =>
      (delete(favoriteMovies)..where((tbl) => tbl.movieId.equals(id))).go();
}

// 3. Hàm tạo file vật lý SQLite trên bộ nhớ điện thoại (Không cần sửa)
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Tìm thư mục gốc của app trên điện thoại
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cinema_app.sqlite')); // Tên file database
    return NativeDatabase.createInBackground(file);
  });
}