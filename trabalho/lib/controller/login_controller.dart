import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String password;

  User({required this.name, required this.email, required this.password});
}

class LoginController {
  static List<User> users = [];

  static void registerUser(String name, String email, String password) {
    User newUser = User(name: name, email: email, password: password);
    users.add(newUser);
  }

  static bool loginUser(String email, String password) {
    for (var user in users) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }
    return false;
  }
}