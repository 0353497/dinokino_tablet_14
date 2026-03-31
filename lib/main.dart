import 'package:dinokino_tablet/pages/login_page.dart';
import 'package:dinokino_tablet/pages/movies_page.dart';
import 'package:dinokino_tablet/providers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
  Get.put<MovieProvider>(MovieProvider()).init();
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: isLoggedIn ? MoviesPage() : LoginPage());
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUser = prefs.getString("loggedInUser");
    if (loggedInUser == null) {
      isLoggedIn = false;
      setState(() {});
      return;
    }
    if (loggedInUser.isEmpty) {
      isLoggedIn = false;
      setState(() {});
      return;
    }
    isLoggedIn = true;
    setState(() {});
  }
}
