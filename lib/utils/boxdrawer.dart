import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:letters_game/utils/screen_utils.dart';

void drawBox({
  required double row,
  required int col,
  int startRow = 1,
  int startCol = 1,
  Chalk? color,
  bool centered = false,
}) {
  const horizontal = '─';
  const vertical = '│';
  const topLeft = '╭';
  const topRight = '╮';
  const bottomLeft = '╰';
  const bottomRight = "╯";


  String style(String char) => color != null ? color(char) : char;

  int actualStartCol = startCol;
  if (centered) {
    int terminalWidth = stdout.terminalColumns;
    actualStartCol = ((terminalWidth - col) / 2).round();
  }

  setCursorPosition(startRow, actualStartCol);
  stdout.write(style(topLeft));
  stdout.write(style(horizontal * (col - 2)));
  stdout.write(style(topRight));

  for (int i = 1; i < row - 1; i++) {
    setCursorPosition(startRow + i, actualStartCol);
    stdout.write(style(vertical));
    setCursorPosition(startRow + i, actualStartCol + col - 1);
    stdout.write(style(vertical));
  }

  setCursorPosition(startRow + row.toInt() - 1, actualStartCol);
  stdout.write(style(bottomLeft));
  stdout.write(style(horizontal * (col - 2)));
  stdout.write(style(bottomRight));
}
