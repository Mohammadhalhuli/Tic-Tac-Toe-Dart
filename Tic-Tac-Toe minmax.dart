import 'dart:io';

// Defining class
class Move {
    int row;
    int col;
    /*void Move(int row, int col) {
      row = this.row;
      col = this.col;
    }*/
    /*void Move(){

    }*/
    Move({this.row = -1, this.col = -1});
}

void main() {
    List<List<String>> board = [
                                   [' ', ' ', ' '],
                                   [' ', ' ', ' '],
                                   [' ', ' ', ' ']
                               ];
    String HUMAN = 'X';
    String minmax = 'O';
    int WIN_STATE = 2;
    int LOSE_STATE = -2;
    int DRAW_STATE = 1;
    int NOT_FINISHED_STATE = 0;
    print('--- ex 0 0--->\n|X| | |\n| | | |\n| | | |');
    while (checkGameState(board, HUMAN, minmax) == NOT_FINISHED_STATE) {
        print('\n\nEnter row and column :');
        List<String> input = stdin.readLineSync()!.split(' ');
        int x = int.parse(input[0]);
        int y = int.parse(input[1]);

        if (board[x][y] == ' ') {
            board[x][y] = HUMAN;
            displayBoard(board);

            if (checkGameState(board, HUMAN, minmax) != NOT_FINISHED_STATE) {
                break;
            }

            Move bestMove = findBestMove(board, minmax);
            print('Best move: ${bestMove.row} row, ${bestMove.col} col');
            board[bestMove.row][bestMove.col] = minmax;
            displayBoard(board);
        } else {
            print('Cell is already filled.');
        }
    }

    int gameState = checkGameState(board, HUMAN, minmax);
    if (gameState == DRAW_STATE) {
        print('It is a Draw!');
    } else if (gameState == WIN_STATE) {
        print('The Winner is O!');
    } else if (gameState == LOSE_STATE) {
        print('The Winner is X!');
    }
}

Move findBestMove(List<List<String>> board, String player) {
    int bestVal = -1000;
    Move bestMove = Move();

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ') {
                board[i][j] = player;
                int moveVal = minimax(board, 0, false, player);
                board[i][j] = ' ';

                if (moveVal > bestVal) {
                    bestMove.row = i;
                    bestMove.col = j;
                    bestVal = moveVal;
                }
            }
        }
    }
    return bestMove;
}

int minimax(List<List<String>> board, int depth, bool isMax, String player) {
    int score = checkGameState(board, 'X', 'O');

    if (score != 0) {
        return score;
    }

    if (isMax) {
        int best = -1000;

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == ' ') {
                    board[i][j] = player;
                    best = max(best, minimax(board, depth + 1, !isMax, player));
                    board[i][j] = ' ';
                }
            }
        }
        return best;
    } else {
        int best = 1000;

        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (board[i][j] == ' ') {
                    board[i][j] = player == 'X' ? 'O' : 'X';
                    best = min(best, minimax(board, depth + 1, !isMax, player));
                    board[i][j] = ' ';
                }
            }
        }
        return best;
    }
}

int checkGameState(List<List<String>> board, String human, String minmax) {
    // Check rows, columns, and diagonals for win conditions
    for (int i = 0; i < 3; i++) {
        if (board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
            if (board[i][0] == minmax) {
                return 2;
            }
            if (board[i][0] == human) {
                return -2;
            }
        }

        if (board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
            if (board[0][i] == minmax) {
                return 2;
            }
            if (board[0][i] == human) {
                return -2;
            }
        }
    }

    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] ||
            board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
        if (board[1][1] == minmax) {
            return 2;
        }
        if (board[1][1] == human) {
            return -2;
        }
    }

    // Check for draw
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == ' ') {
                isDraw = false;
            }
        }
    }

    if (isDraw) return 1;

    return 0;
}

void displayBoard(List<List<String>> board) {
    for (var row in board) {
        print("|${row.join('|')}|");
    }
}


int max(int a, int b) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

int min(int a, int b) {
    if (a < b) {
        return a;
    } else {
        return b;
    }
}