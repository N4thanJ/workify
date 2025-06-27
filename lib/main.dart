import 'package:flutter/material.dart';
import 'package:workify/routes/router.dart';

// Define a basic AppTheme class with light and dark themes
class AppTheme {
  static final ThemeData light = ThemeData.light();
  static final ThemeData dark = ThemeData.dark();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.hero,
      routes: AppRoutes.routes,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
