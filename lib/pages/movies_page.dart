import 'dart:convert';
import 'dart:io';

import 'package:dinokino_tablet/models/movie.dart';
import 'package:dinokino_tablet/models/user.dart';
import 'package:dinokino_tablet/pages/login_page.dart';
import 'package:dinokino_tablet/pages/video_page.dart';
import 'package:dinokino_tablet/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key, this.isFromVideo = false, this.fromVideoMovie});
  final bool isFromVideo;
  final Movie? fromVideoMovie;

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  bool isAllmovies = true;
  final MovieProvider movieProvider = Get.find<MovieProvider>();
  Movie selectedMovie = Get.find<MovieProvider>().allMovies.first;
  late final SharedPreferences prefs;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/bg.png", fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/logo_small.png"),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isAllmovies = true;
                            });
                          },
                          child: Text(
                            "All movies",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decorationColor: Colors.white,
                              decoration: isAllmovies
                                  ? TextDecoration.underline
                                  : null,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isAllmovies = false;
                            });
                          },
                          child: Text(
                            "My favorites",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decoration: !isAllmovies
                                  ? TextDecoration.underline
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Text(
                          currentUser?.username ?? "Steve",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Get.dialog(
                              ProfileDialog(currentUser: currentUser!),
                            );
                            if (mounted) {
                              updatedUser();
                            }
                          },
                          child: CircleAvatar(
                            radius: 40,
                            foregroundImage: currentUser?.imagePath != null
                                ? FileImage(File(currentUser!.imagePath!))
                                : AssetImage("assets/images/profile_steve.png"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (movieProvider.favoriteMovies.isEmpty && !isAllmovies)
                  Center(
                    child: Text(
                      "no favorite movies yet",
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                Column(
                  children: [
                    if (!(movieProvider.favoriteMovies.isEmpty && !isAllmovies))
                      selectedWidget(),
                    if (!isAllmovies) favoriteMovieList(),
                    if (isAllmovies) allMovieList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox allMovieList() {
    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 12,
          children: [
            for (int i = 0; i < movieProvider.allMovies.length; i++)
              DinoCard(
                movie: movieProvider.allMovies[i],
                onTap: () {
                  setState(() {
                    selectedMovie = movieProvider.allMovies[i];
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  SizedBox favoriteMovieList() {
    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 12,
          children: [
            for (int i = 0; i < movieProvider.favoriteMovies.length; i++)
              DinoCard(
                movie: movieProvider.favoriteMovies[i],
                onTap: () {
                  setState(() {
                    selectedMovie = movieProvider.favoriteMovies[i];
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Container selectedWidget() {
    return Container(
      height: Get.height * .5,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: Image.asset(
                "assets/${selectedMovie.image}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedMovie.title,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        Icon(
                          Icons.star,
                          color: i < selectedMovie.rating
                              ? Color(0xff00C8C4)
                              : Colors.grey,
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 500,
                    child: Text(
                      selectedMovie.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 60,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xff00C8C4),
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.black,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(16),
                              ),
                            ),
                          ),
                          onPressed: () =>
                              Get.to(() => VideoPage(movie: selectedMovie)),
                          child: Row(
                            spacing: 12,
                            children: [
                              Icon(Icons.play_arrow, size: 32),
                              Text(
                                "Start movie",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 60,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.grey.shade800,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(16),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (!selectedMovie.isFavorite) {
                              movieProvider.favoriteMovies.add(selectedMovie);
                            } else {
                              movieProvider.favoriteMovies.remove(
                                selectedMovie,
                              );
                            }
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 12,
                            children: [
                              Icon(
                                selectedMovie.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 32,
                              ),
                              Text(
                                "Favorite",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    updatedUser();
  }

  void updatedUser() {
    final userString = prefs.getString("loggedInUser");
    if (userString == null) return;
    currentUser = User.fromJson(jsonDecode(userString));
    setState(() {});
  }
}

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key, required this.currentUser});
  final User currentUser;

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  String? pickedImage;

  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController.fromValue(
      TextEditingValue(text: widget.currentUser.username),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white70,
      child: SizedBox(
        width: Get.width * .4,
        height: Get.height * .6,
        child: BackdropFilter(
          filterConfig: ImageFilterConfig.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => signOut(),
                      child: Text(
                        "Sign out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      child: Badge(
                        alignment: Alignment(.6, .6),
                        backgroundColor: Color(0xff00C8C4),
                        label: SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () async {
                              final xfileImage = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              setState(() {
                                pickedImage = xfileImage?.path;
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          foregroundImage: pickedImage != null
                              ? FileImage(File(pickedImage!))
                              : AssetImage("assets/images/profile_empty.png"),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your name",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 400,
                          height: 60,
                          child: TextField(
                            controller: nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  height: 60,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xff00C8C4),
                      ),
                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(16),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final User updatedUser = widget.currentUser.copyWith(
                        username: nameController.value.text,
                        imagePath: pickedImage,
                      );
                      prefs.setString("loggedInUser", jsonEncode(updatedUser));
                      Get.back();
                    },
                    child: Text("Save", style: TextStyle(fontSize: 24)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("loggedInUser", "");
    Get.to(() => LoginPage());
  }
}

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, required this.movie});
  final Movie movie;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double angle = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .6,
      height: Get.height * .8,
      child: Dialog(
        backgroundColor: Colors.white70,
        child: BackdropFilter(
          filterConfig: ImageFilterConfig.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    "Did you like the movie?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    height: Get.height * .4,
                    width: 200,
                    child: Center(
                      child: Column(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/thumb_down.png"),
                          Text(
                            "No, not at all",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    height: Get.height * .4,
                    width: 200,
                    child: Draggable<String>(
                      feedback: Material(
                        child: SizedBox(
                          height: 250,
                          width: 130,
                          child: Transform.rotate(
                            angle: angle,
                            child: DinoCard(movie: widget.movie, onTap: () {}),
                          ),
                        ),
                      ),
                      onDragUpdate: (details) {
                        setState(() {
                          angle = details.delta.distance;
                        });
                      },
                      child: Material(
                        child: SizedBox(
                          height: 250,
                          width: 130,
                          child: DinoCard(movie: widget.movie, onTap: () {}),
                        ),
                      ),
                    ),
                  ),
                  DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        height: Get.height * .4,
                        width: 200,
                        child: Center(
                          child: Column(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/thumb_up.png"),
                              Text(
                                "Yesm I loved it",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text(
                "Drag the thumbnail rate",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 60,
                width: 200,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white54),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Rate"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DinoCard extends StatelessWidget {
  const DinoCard({super.key, required this.movie, required this.onTap});
  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        padding: EdgeInsets.all(8),
        height: 250 - 12,
        width: 130,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: Image.asset(
                    "assets/${movie.image}",
                    fit: BoxFit.cover,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
                Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        Icons.star,
                        size: 16,
                        color: i < movie.rating
                            ? Color(0xff00C8C4)
                            : Colors.grey,
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (movie.isFavorite)
                    Icon(Icons.favorite, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
