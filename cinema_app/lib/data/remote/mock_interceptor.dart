import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import '../mock/mock_data.dart';

class MockInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (request.url.path.endsWith('/movies') && request.method == HttpMethod.Get) {
      final movies = MockData.getMovies().map((e) => {
        'id': e.id,
        'title': e.title,
        'posterUrl': e.posterUrl,
        'rating': e.rating,
        'durationMinutes': e.durationMinutes,
        'basePrice': e.basePrice,
        'genres': e.genres,
      }).toList();

      final response = http.Response(jsonEncode(movies), 200, headers: {'content-type': 'application/json'});
      return Response(response, response.body as BodyType); // Chopper Converter sẽ lo việc parse JSON
    }

    if (request.url.path.contains('/movies/') && request.method == HttpMethod.Get && !request.url.path.endsWith('/showtimes')) {
      final id = request.url.pathSegments.last;
      final movie = MockData.getMovies().firstWhere((e) => e.id == id);
      
      final movieJson = {
        'id': movie.id,
        'title': movie.title,
        'posterUrl': movie.posterUrl,
        'rating': movie.rating,
        'durationMinutes': movie.durationMinutes,
        'basePrice': movie.basePrice,
        'genres': movie.genres,
      };

      final response = http.Response(jsonEncode(movieJson), 200, headers: {'content-type': 'application/json'});
      return Response(response, response.body as BodyType); // Chopper Converter sẽ lo việc parse JSON
    }

    // Default error for unmocked routes
    return chain.proceed(request);
  }
}
