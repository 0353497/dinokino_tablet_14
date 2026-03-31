import 'package:get/state_manager.dart';

class UserProvider extends GetxController {
  final String username;
  final String password;
  final String email;

  UserProvider({
    required this.password,
    required this.username,
    required this.email,
  });
}
