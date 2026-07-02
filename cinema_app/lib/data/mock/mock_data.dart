import '../models/movie.dart';
import '../models/seat.dart';
import '../models/room.dart';
import '../models/showtime.dart';
import '../models/review.dart';
import '../models/user.dart';

class MockData {
  static List<Movie> getMovies() {
    return const [
      Movie(
        id: 'm1',
        title: 'Lật Mặt 7: Một Điều Ước',
        posterUrl: 'https://i.imgur.com/mnOlHB0.jpg',
        rating: 8.5,
        durationMinutes: 120,
        basePrice: 90000,
        genres: ['Drama', 'Family'], // Thêm genres
      ),
      Movie(
        id: 'm2',
        title: 'Mai',
        posterUrl: 'https://cdn-images.vtv.vn/562122370168008704/2023/11/28/photo-1-17011453442011344132442.jpg',
        rating: 7.9,
        durationMinutes: 130,
        basePrice: 100000,
        genres: ['Romance', 'Drama'], // Thêm genres
      ),
    ];
  }

  static List<Room> getRooms() {
    return const [
      Room(id: 'r1', name: 'Phòng 1 (Standard)'),
      Room(id: 'r2', name: 'Phòng 2 (IMAX)'),
    ];
  }

  static List<Showtime> getShowtimes() {
    return [
      Showtime(
        id: 's1',
        movieId: 'm1', // Lật Mặt 7
        roomId: 'r1', // Phòng 1
        startTime: DateTime.now().add(const Duration(hours: 2)),
        dynamicPricingFactor: 1.0, // Giờ bình thường
      ),
      Showtime(
        id: 's2',
        movieId: 'm2', // Mai
        roomId: 'r2', // Phòng IMAX
        startTime: DateTime.now().add(const Duration(hours: 5)),
        dynamicPricingFactor: 1.2, // Giờ cao điểm hoặc phòng xịn
      ),
    ];
  }

  static List<Seat> getSeats() {
    List<Seat> seats = [];
    List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F'];
    for (String row in rows) {
      for (int i = 1; i <= 8; i++) {
        // Giả lập trạng thái ghế
        SeatStatus status = SeatStatus.available;
        if ((row == 'C' || row == 'D') && (i >= 3 && i <= 6)) {
          status = (i % 2 == 0) ? SeatStatus.booked : SeatStatus.available;
        }
        
        // Phân loại ghế
        SeatType type = SeatType.standard;
        if (row == 'C' || row == 'D') type = SeatType.vip;
        if (row == 'F') type = SeatType.sweetbox;

        seats.add(Seat(
          id: '$row$i',
          row: row,
          number: i,
          status: status,
          type: type, // Truyền loại ghế vào
        ));
      }
    }
    return seats;
  }

  static List<User> getUsers() {
    return const [
      User(
        id: 'u1',
        name: 'Nguyễn Văn A',
        email: 'vana@example.com',
        favoriteMovieIds: ['m1'],
      ),
    ];
  }

  static List<Review> getReviews() {
    return const [
      Review(
        id: 'rv1',
        movieId: 'm1',
        userId: 'u1',
        rating: 9.0,
        content: 'Phim rất cảm động, đáng xem!',
        hasSpoilers: false,
      ),
    ];
  }
}
