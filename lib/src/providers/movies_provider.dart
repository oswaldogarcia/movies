import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/models/movie_model.dart';

class MoviesProvider {
  String _apikey = '532e171f8d42fd5a1d2a2e8d63732ede';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _poularPage = 0;
  bool _loading = false;

  List<Movie> _popularMovies = new List();

  final _popularMoviesStreamController =
      StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularMoviesSink =>
      _popularMoviesStreamController.sink.add;

  Stream<List<Movie>> get popularMoviesStream =>
      _popularMoviesStreamController.stream;

  void disposesStreams() {
    _popularMoviesStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodeData = json.decode(response.body);

    final movies = Movies.fromJsonList(decodeData['results']);

    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loading) return [];

    _loading = true;

    _poularPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _poularPage.toString()
    });

    final response = await _processResponse(url);

    _popularMovies.addAll(response);
    popularMoviesSink(_popularMovies);
    _loading = false;
    return response;
  }

  Future<List<Actor>> getCast(String movieId) async {

    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apikey, 'language': _language});

    final response = await http.get(url);
    final decodeData = json.decode(response.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);
    return cast.actors;
  }


  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 
        'language': _language,
        'query'   : query
        });

    return await _processResponse(url);
  }

}
