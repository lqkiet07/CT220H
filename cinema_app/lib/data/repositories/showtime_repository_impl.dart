import '../../domain/repositories/showtime_repository.dart';
import '../models/showtime.dart';
import '../models/seat.dart';
import '../remote/api_service.dart';

class ShowtimeRepositoryImpl implements ShowtimeRepository {
  final ApiService _apiService;

  ShowtimeRepositoryImpl(this._apiService);

  @override
  Future<List<Showtime>> getShowtimesByMovie(String movieId) async {
    try {
      final response = await _apiService.getShowtimes(movieId);

      if (response.isSuccessful) {
        final List data = response.body;
        return data.map((json) => Showtime.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Không thể tải suất chiếu: $e');
    }
  }

  @override
  Future<List<Seat>> getSeatsByShowtime(String showtimeId) async {
    try {
      final response = await _apiService.getSeats(showtimeId);

      if (response.isSuccessful) {
        final List data = response.body;
        return data.map((json) => Seat.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Không thể tải sơ đồ ghế: $e');
    }
  }
}