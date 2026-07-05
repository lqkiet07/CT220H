// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ApiService extends ApiService {
  _$ApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ApiService;

  @override
  Future<Response<dynamic>> getMovies() {
    final Uri $url = Uri.parse('/api/movies');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMovieDetail(String movieId) {
    final Uri $url = Uri.parse('/api/movies/${movieId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getSeats(String showtimeId) {
    final Uri $url = Uri.parse('/api/showtimes/${showtimeId}/seats');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> bookTicket(Map<String, dynamic> ticketData) {
    final Uri $url = Uri.parse('/api/tickets/book');
    final $body = ticketData;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
