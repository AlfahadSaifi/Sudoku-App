import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku/screens/sudoku_grid_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Function to navigate to the next screen after a delay
  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SudokuGridScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[Color(0xFF4E65FF), Color(0xFF92EFFD)],
            ),
          ),
          child: Center(
            child: Text(
              "Sudoku",
              style: TextStyle(
                fontFamily: GoogleFonts.questrial().fontFamily,
                fontSize: 50,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.normal,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
