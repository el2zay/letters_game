import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:letters_game/letters_game.dart';

void enableAlternateScreen() {
  stdout.write('\x1b[?1049h');
  setCursorPosition((terminalHeight * 0.18).floor(), 0);
}

void disableAlternateScreen() {
  stdout.write('\x1b[?1049l');

  stdout.write('\x1b[?25h');
}

void setCursorPosition(num row, num col) {
  stdout.write('\x1b[0;0H');
  stdout.write('\x1b[${row.toInt()};${col.toInt()}H');
}

void clearScreen() {
  stdout.write('\x1b[2J');
  setCursorPosition(0, 0);
}

void colorScreen(Chalk color) {
  for (int i = 0; i < terminalHeight; i++) {
    setCursorPosition(i + 1, 0);
    stdout.write(color(' ' * terminalWidth));
  }
}
