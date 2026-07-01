import 'package:chopper/chopper.dart';

// TODO: (Thành viên A) Bỏ comment dòng dưới ở Giai đoạn 2
// part 'api_service.chopper.dart'; 

// @ChopperApi(baseUrl: '/api')
abstract class ApiService extends ChopperService {
  
  // TODO: (Thành viên A) Định nghĩa các Endpoint API tại đây
  // @Get(path: '/movies')
  // Future<Response> getMovies();

  static ApiService create([ChopperClient? client]) {
    // return _$ApiService(client);
    throw UnimplementedError("Hàm này sẽ được chạy khi sinh code ở Giai đoạn 2");
  }
}
