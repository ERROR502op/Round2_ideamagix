import 'package:ecommerce/screens/homescreen.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/onbordingscreen.dart';
import 'package:ecommerce/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ideammagix E-Commerce',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.orange,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
      ),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
