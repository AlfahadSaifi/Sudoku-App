import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/logic/sudoku_solver.dart';

import 'package:sudoku/screens/multi_screen.dart';

import '../logic/sudoku_generator.dart';
import 'dart:async'; // Import for Timer

class SudokuGridScreen extends StatefulWidget {
  const SudokuGridScreen({super.key});

  @override
  State<SudokuGridScreen> createState() => SudokuGridScreenState();
}

class SudokuGridScreenState extends State<SudokuGridScreen> {
  //Object for sudoku solver
  final SudokuGenerator _generator = SudokuGenerator();
  final SudokuSolver _solver = SudokuSolver();

  List<List<int>> _initialValues = [];
  List<List<int>> _gridValues = [];

  final FocusNode focusNode = FocusNode();

  int secondsElapsed = 900;
  Timer? timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _initialValues = _generator.generateRandomSudoku();
    _gridValues = List.generate(9, (_) => List.filled(9, 0));
    _gridValues = List.generate(9, (row) => List.from(_initialValues[row]));
    secondsElapsed = 900;
    timer?.cancel();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    focusNode.dispose();
    super.dispose();
  }

  void _startNewGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SudokuGridScreen(),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && secondsElapsed > 0) {
        setState(() {
          secondsElapsed--;
        });
      }
      if (secondsElapsed == 0) {
        timer.cancel();
        // Call the method to show the dialog
        showOutOfTimeDialog();
      }
    });
  }

  String formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  void showOutOfTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiScreen(
          onAction: _startNewGame,
          message: "Out of Time",
          buttonLabel: "Start New Game",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF92EFFD),
      appBar: AppBar(
        title: const Center(child: Text('Sudoku')),
        actions: [
          if (!isPaused && secondsElapsed > 0)
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                setState(() {
                  isPaused = !isPaused;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MultiScreen(
                      onAction: () {
                        setState(() {
                          isPaused = !isPaused;
                        });
                        Navigator.of(context).pop();
                      },
                      message: "Game paused",
                      buttonLabel: "Resume",
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9, // 9x9 grid for Sudoku
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 9;
                    int col = index % 9;
                    int value = _gridValues[row][col];

                    bool isInitialValue = _initialValues[row][col] != 0;
                    bool isConflicting =
                        _solver.isCellConflicting(_gridValues, row, col, value);
                    BorderSide topBorder =
                        const BorderSide(width: 1, color: Colors.black);
                    BorderSide bottomBorder =
                        const BorderSide(width: 1, color: Colors.black);
                    BorderSide leftBorder =
                        const BorderSide(width: 1, color: Colors.black);
                    BorderSide rightBorder =
                        const BorderSide(width: 1, color: Colors.black);

                    // Adjust bottom border for every 3rd row
                    if ((row + 1) % 3 == 0 && row != 8) {
                      bottomBorder =
                          const BorderSide(width: 2, color: Colors.black);
                    }

                    // Adjust right border for every 3rd column
                    if ((col + 1) % 3 == 0 && col != 8) {
                      rightBorder =
                          const BorderSide(width: 2, color: Colors.black);
                    }

                    return GestureDetector(
                      onTap: () {
                        // Open a dialog to input numbers only for empty cells
                        if (!isInitialValue) {
                          focusNode.requestFocus();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Enter a number'),
                                content: TextField(
                                  focusNode: focusNode,
                                  controller: TextEditingController(
                                      text: value != 0 ? '$value' : ''),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[1-9]')),
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  onChanged: (input) {
                                    setState(() {
                                      _gridValues[row][col] =
                                          int.tryParse(input) ?? 0;
                                    });
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      if (_solver.isGridFilled(_gridValues) &&
                                          _solver
                                              .isSolutionCorrect(_gridValues)) {
                                        timer?.cancel();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MultiScreen(
                                              onAction: _startNewGame,
                                              message:
                                                  "Congratulations You Win",
                                              buttonLabel: "Play Again",
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: topBorder,
                            bottom: bottomBorder,
                            left: leftBorder,
                            right: rightBorder,
                          ),
                          color: isInitialValue
                              ? const Color(0xFF92EFFD)
                              : isConflicting
                                  ? Colors.red
                                  : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          value != 0 ? '$value' : '',
                          style: TextStyle(
                            fontSize: 20,
                            color: _initialValues[row][col] != 0
                                ? Colors.black
                                : Colors.blue,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 81,
                ),
              ),
              Center(
                child: Text(
                  formatTimer(secondsElapsed),
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
