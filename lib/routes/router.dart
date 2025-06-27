import 'package:flutter/material.dart';
import 'package:workify/features/login/login_page.dart';
import '../features/home/home_page.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const MyHomePage(
      title: "Workify",
      description: "Track your workhours easily.",
    ),
    login: (context) => const LoginPage(title: "Login"),
  };
}
