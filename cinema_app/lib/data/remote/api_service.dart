import 'package:chopper/chopper.dart';


part 'api_service.chopper.dart';


@ChopperApi(baseUrl: '/api')
abstract class ApiService extends ChopperService {


  // API 1: Lấy danh sách phim đang chiếu
  @Get(path: '/movies')
  Future<Response> getMovies();

  // API 2: Lấy chi tiết một bộ phim cụ thể (truyền ID phim vào)
  @Get(path: '/movies/{id}')
  Future<Response> getMovieDetail(@Path('id') String movieId);

  // API 3: Lấy sơ đồ ghế của một suất chiếu
  @Get(path: '/showtimes/{showtimeId}/seats')
  Future<Response> getSeats(@Path('showtimeId') String showtimeId);

  // API 4: Đặt vé (Gửi dữ liệu người dùng đặt lên server)
  @Post(path: '/tickets/book')
  Future<Response> bookTicket(@Body() Map<String, dynamic> ticketData);


  static ApiService create([ChopperClient? client]) {
        return _$ApiService(client);
  }
}