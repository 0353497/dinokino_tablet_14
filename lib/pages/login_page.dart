import 'dart:convert';

import 'package:dinokino_tablet/models/user.dart';
import 'package:dinokino_tablet/pages/movies_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                ),
              ),
            ),
          ),
          Center(
            child: SafeArea(
              child: SizedBox(
                width: Get.width * .33,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/logo_large.png",
                        width: double.maxFinite,
                        height: 200,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 70,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: double.maxFinite,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      !isLogin
                                          ? Colors.transparent
                                          : Color(0xff00C8C4),
                                    ),
                                    foregroundColor: WidgetStatePropertyAll(
                                      !isLogin ? Colors.white : Colors.black,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(16),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLogin = true;
                                    });
                                  },
                                  child: Text("Log in"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    !isLogin
                                        ? Color(0xff00C8C4)
                                        : Colors.transparent,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    isLogin ? Colors.white : Colors.black,
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(16),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                                child: Text("Sign up"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email address",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null) {
                                  return "value can not be empty";
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return "is not a valid email";
                                }

                                if (!isLogin) {
                                  if (emailAlreadyExists()) {
                                    return "email aready exists";
                                  }
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            Text(
                              "Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              validator: (value) {
                                if (!isLogin) {
                                  if (value == null) {
                                    return "value can not be empty";
                                  }
                                  if (!value.contains(RegExp(r"[a-z]"))) {
                                    return "must contain lowercase";
                                  }
                                  if (!value.contains(RegExp(r"[A-Z]"))) {
                                    return "must contain Uppercase";
                                  }
                                  if (!value.contains(RegExp("[0-9]"))) {
                                    return "must contain number";
                                  }
                                  if (value.length < 8) {
                                    return "value must be atleast 8 chars";
                                  }
                                } else {
                                  final user = getUserFromEmail();
                                  if (user == null) {
                                    return "user not found";
                                  }
                                  if (user.password !=
                                      passwordController.value.text) {
                                    return "incorrect password";
                                  }
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              width: double.maxFinite,
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
                                      borderRadius:
                                          BorderRadiusGeometry.circular(16),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  handleForm();
                                },
                                child: Text("Log in"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool emailAlreadyExists() {
    List<String>? allUsers = prefs.getStringList("allUsers");

    allUsers ??= [];
    return allUsers.any(
      (userString) =>
          User.fromJson(jsonDecode(userString)).email ==
          emailController.value.text.trim(),
    );
  }

  void handleForm() async {
    if (formKey.currentState?.validate() ?? false) {
      List<String>? allUsers = prefs.getStringList("allUsers");

      allUsers ??= [];
      late User loggedInUser;
      if (!isLogin) {
        loggedInUser = handleSignUpForm(allUsers);
      } else {
        loggedInUser = handleSignInForm(allUsers);
      }

      prefs.setString("loggedInUser", jsonEncode(loggedInUser.toJson()));

      Get.to(() => MoviesPage());
    }
  }

  User handleSignUpForm(List<String> allUsers) {
    int startingIndex = 1000;
    startingIndex += allUsers.length;

    final User userToAdd = User(
      username: "user_$startingIndex",
      password: passwordController.value.text,
      email: emailController.value.text,
    );

    final newUser = jsonEncode(userToAdd.toJson());
    allUsers.add(newUser);
    prefs.setStringList("allUsers", allUsers);
    return userToAdd;
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  User handleSignInForm(List<String> allUsers) {
    final loggedInUserString = allUsers.firstWhere((userString) {
      final user = User.fromJson(jsonDecode(userString));
      return user.email.toLowerCase() ==
              emailController.value.text.trim().toLowerCase() &&
          user.password == passwordController.value.text;
    });
    return User.fromJson(jsonDecode(loggedInUserString));
  }

  User? getUserFromEmail() {
    List<String>? allUsers = prefs.getStringList("allUsers");

    allUsers ??= [];
    final userString = allUsers.firstWhere(
      (userString) =>
          User.fromJson(jsonDecode(userString)).email ==
          emailController.value.text.trim(),
      orElse: () => "",
    );
    if (userString.isEmpty) return null;
    return User.fromJson(jsonDecode(userString));
  }
}
