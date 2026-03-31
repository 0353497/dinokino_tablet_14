class User {
  final String username;
  final String password;
  final String email;
  final String? imagePath;

  User({
    required this.username,
    required this.password,
    required this.email,
    this.imagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      password: json["password"],
      email: json["email"],
      imagePath: json["imagePath"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "email": email,
      "imagePath": imagePath,
    };
  }
}
