import 'dart:math';

import 'package:sudoku/logic/sudoku_solver.dart';

class SudokuGenerator {
  //object
  SudokuSolver solver = SudokuSolver();

  List<List<int>> generateRandomSudoku() {
    List<List<int>> initialValues = List.generate(9, (_) => List.filled(9, 0));
    _generateRandomSolution(initialValues); // Generate a random solved puzzle
    _removeValuesToCreatePuzzle(
        initialValues); // Create a puzzle by removing values
    return initialValues;
  }

  void _generateRandomSolution(List<List<int>> puzzle) {
    final random = Random();
    for (int num = 1; num <= 9; num++) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      while (!solver.isSafe(puzzle, row, col, num) || puzzle[row][col] != 0) {
        row = random.nextInt(9);
        col = random.nextInt(9);
      }
      puzzle[row][col] = num;
    }
    solver.solveSudoku(puzzle, 0, 0); // Complete the puzzle
  }

  void _removeValuesToCreatePuzzle(List<List<int>> puzzle) {
    final random = Random();
    int remaining = 35; // Adjust this value for difficulty
    while (remaining > 0) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      if (puzzle[row][col] != 0) {
        puzzle[row][col] = 0;
        remaining--;
      }
    }
  }
}
