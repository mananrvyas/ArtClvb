import 'package:flutter/material.dart';
import 'dart:math';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArtClvb',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
