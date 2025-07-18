import 'dart:io';

void enableAlternateScreen() {
  stdout.write('\x1b[?1049h');
}

void disableAlternateScreen() {
  stdout.write('\x1b[?1049l');
}
