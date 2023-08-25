class SudokuSolver {
  bool isCellConflicting(List<List<int>> grid, int row, int col, int value) {
    if (value == 0) {
      return false;
    }

    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == value && i != col) {
        return true;
      }
      if (grid[i][col] == value && i != row) {
        return true;
      }
    }

    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i + startRow][j + startCol] == value &&
            (i + startRow) != row &&
            (j + startCol) != col) {
          return true;
        }
      }
    }

    return false;
  }

  bool isGridFilled(List<List<int>> grid) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  bool isSolutionCorrect(List<List<int>> grid) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        int value = grid[i][j];
        if (value == 0 || isCellConflicting(grid, i, j, value)) {
          return false;
        }
      }
    }
    return true;
  }

  bool isSafe(List<List<int>> puzzle, int row, int col, int num) {
    // Check rows and columns
    for (int x = 0; x < 9; x++) {
      if (puzzle[row][x] == num || puzzle[x][col] == num) {
        return false;
      }
    }

    // Check 3x3 subgrid
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (puzzle[i + startRow][j + startCol] == num) {
          return false;
        }
      }
    }
    return true;
  }

  bool solveSudoku(List<List<int>> puzzle, int row, int col) {
    if (row == 9) {
      row = 0;
      if (++col == 9) {
        return true;
      }
    }

    if (puzzle[row][col] != 0) {
      return solveSudoku(puzzle, row + 1, col);
    }

    for (int num = 1; num <= 9; num++) {
      if (isSafe(puzzle, row, col, num)) {
        puzzle[row][col] = num;
        if (solveSudoku(puzzle, row + 1, col)) {
          return true;
        }
        puzzle[row][col] = 0; // Backtrack
      }
    }

    return false;
  }
}
