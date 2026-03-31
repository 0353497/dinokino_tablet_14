import 'package:dinokino_tablet/providers/movie_provider.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

class Movie {
  final String title;
  final String image;
  final int rating;
  final String description;
  final bool nowPlaying;

  bool get isFavorite {
    final favorites = Get.find<MovieProvider>().favoriteMovies;
    return favorites.any((movie) => movie.title == title);
  }

  bool get isLiked {
    final likedMovies = Get.find<MovieProvider>().likedMovies;
    return likedMovies.any((movie) => movie.title == title);
  }

  bool get isDisliked {
    final dislikedMovies = Get.find<MovieProvider>().dislikedMovies;
    return dislikedMovies.any((movie) => movie.title == title);
  }

  Movie({
    required this.title,
    required this.image,
    required this.rating,
    required this.description,
    required this.nowPlaying,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      image: json["image"],
      rating: json["rating"],
      description: json["description"],
      nowPlaying: json["nowPlaying"],
    );
  }
}
