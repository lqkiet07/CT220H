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

  @Get(path: '/tickets/history')
  Future<Response> getTicketHistory();

  @Get(path: '/movies/{id}/showtimes')
  Future<Response> getShowtimes(@Path('id') String movieId);

  // API Đăng nhập
  @Post(path: '/auth/login')
  Future<Response> login(@Body() Map<String, dynamic> body);

  // API Đăng ký
  @Post(path: '/auth/register')
  Future<Response> register(@Body() Map<String, dynamic> body);

  // API Lấy thông tin cá nhân
  @Get(path: '/auth/profile')
  Future<Response> getUserProfile();
  static ApiService create([ChopperClient? client]) {
        return _$ApiService(client);
  }
}