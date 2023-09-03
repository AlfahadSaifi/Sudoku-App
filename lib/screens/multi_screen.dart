import 'dart:ui';
import 'package:flutter/material.dart';

class MultiScreen extends StatelessWidget {
  final VoidCallback onAction;

  final String message;
  final String buttonLabel;

  const MultiScreen({
    Key? key,
    required this.onAction,
    required this.message,
    required this.buttonLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: onAction,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      ThemeData.dark().scaffoldBackgroundColor),
                ),
                child: Text(
                  buttonLabel,
                  style:
                      const TextStyle(color: Colors.amberAccent, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
