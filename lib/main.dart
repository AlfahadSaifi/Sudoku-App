import 'package:flutter/material.dart';
import 'package:sudoku/screens/splash_screen.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku App',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
