import 'package:flutter/material.dart';
import 'package:workify/features/home/home_page.dart';
import 'package:workify/features/login/login_page.dart';
import 'package:workify/features/register/register_page.dart';
import '../features/hero/hero_page.dart';

class AppRoutes {
  static const hero = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static Map<String, WidgetBuilder> routes = {
    hero: (context) => const HeroPage(
      title: "Workify",
      description: "Track your workhours easily.",
    ),
    login: (context) => const LoginPage(title: "Login"),
    register: (context) => const RegisterPage(title: "Register"),
    home: (context) => const HomePage(title: "Homepage"),
  };
}
