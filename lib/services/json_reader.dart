import 'dart:convert';

import 'package:dinokino_tablet/models/movie.dart';
import 'package:flutter/services.dart';

class JsonReader {
  static Future<List<Movie>> getMovies() async {
    final json = await rootBundle.loadString("assets/data/movies.json");
    final List data = await jsonDecode(json);
    return data.map((movie) => Movie.fromJson(movie)).toList();
  }
}
