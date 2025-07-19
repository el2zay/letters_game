import 'dart:io';

import 'package:letters_game/letters_game.dart';


void enableAlternateScreen() {
  stdout.write('\x1b[?1049h');
  setCursorPosition((terminalHeight * 0.18).floor(), 0);
}

void disableAlternateScreen() {
  stdout.write('\x1b[?1049l');

  stdout.write('\x1b[?25h');
}

void setCursorPosition(int row, int col) {
  stdout.write('\x1b[$row;${col}H');
}