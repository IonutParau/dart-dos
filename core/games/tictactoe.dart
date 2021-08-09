import 'dart:io';

import '../kernel.dart';

void tictactoe() {
  bool equal3(a, b, c) => a == b && b == c;
  final board = [
    [
      ' ',
      ' ',
      ' ',
    ],
    [
      ' ',
      ' ',
      ' ',
    ],
    [
      ' ',
      ' ',
      ' ',
    ],
  ];
  var player1 = true;
  var winner = '';
  while (winner == '') {
    final playerchar = (player1 ? 'X' : 'O');

    for (var i = 0; i < 3; i++) {
      if (equal3(board[i][0], board[i][1], board[i][2]) && board[i][0] != ' ') {
        winner = playerchar;
      }
    }
    for (var i = 0; i < 3; i++) {
      if (equal3(board[0][i], board[1][i], board[2][i]) && board[0][i] != ' ') {
        winner = playerchar;
      }
    }
    if (equal3(board[0][0], board[1][1], board[2][2]) && board[1][1] != ' ') {
      winner = playerchar;
    }
    if (equal3(board[2][0], board[1][1], board[0][2]) && board[1][1] != ' ') {
      winner = playerchar;
    }

    for (var i = 0; i < 3; i++) {
      write(board[i][0] + board[i][1] + board[i][2] + '\n');
    }

    print('Input position.');
    write('X > ');
    final x = int.parse(stdin.readLineSync() ?? '');
    write('\n');
    write('Y > ');
    final y = int.parse(stdin.readLineSync() ?? '');

    board[x][y] = playerchar;
    player1 = !player1;
  }
}
