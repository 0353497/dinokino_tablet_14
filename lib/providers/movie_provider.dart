import 'package:dinokino_tablet/models/movie.dart';
import 'package:dinokino_tablet/services/json_reader.dart';
import 'package:get/get.dart';

class MovieProvider extends GetxController {
  Future init() async {
    allMovies.value = await JsonReader.getMovies();
  }

  final RxList<Movie> allMovies = <Movie>[].obs;

  final RxList<Movie> favoriteMovies = <Movie>[].obs;
  final RxList<Movie> dislikedMovies = <Movie>[].obs;
  final RxList<Movie> likedMovies = <Movie>[].obs;
}
