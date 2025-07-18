import 'package:letters_game/letters_game.dart';

String printWithPadding(String text, int left, int right) {
  return ' ' * left + text + ' ' * right;
}

String printCentered(String text) {
  int visibleLength = getVisibleLength(text);
  int padding = ((terminalWidth - visibleLength) / 2).floor();
  int rightPadding = terminalWidth - visibleLength - padding;

  return printWithPadding(text, padding, rightPadding);
}

int getVisibleLength(String text) {
  final ansiRegex = RegExp(r'\x1B\[[0-9;]*[mK]');
  return text.replaceAll(ansiRegex, '').length;
}
