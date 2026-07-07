import 'package:flutter/material.dart';
import '../../../data/models/movie.dart';
import '../../../domain/repositories/movie_repository.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepository _movieRepository;

  MovieProvider(this._movieRepository);

  List<Movie> _trendingMovies = [];
  List<Movie> get trendingMovies => _trendingMovies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  Future<void> fetchTrendingMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _trendingMovies = await _movieRepository.getTrendingMovies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
