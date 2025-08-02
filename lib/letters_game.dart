import 'dart:io';
import 'dart:math';

import 'package:chalkdart/chalk.dart';
import 'package:dart_console/dart_console.dart';
import 'package:letters_game/resources/en_dictionary.dart';
import 'package:letters_game/resources/fr_dictionary.dart';
import 'package:letters_game/utils/boxdrawer.dart';
import 'package:letters_game/utils/screen_utils.dart';
import 'package:letters_game/utils/style_utils.dart';

import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';

var terminalWidth = stdout.terminalColumns;
var terminalHeight = stdout.terminalLines;
final console = Console();
String inputWord = "";
List<String> wordsFound = [];
List<String> words = frWords;
bool showErrorMsg = false;

void main() async {
  enableAlternateScreen();
  console.hideCursor();
  ProcessSignal.sigint.watch().listen((_) {
    disableAlternateScreen();
    exit(0);
  });
  await initializeMessages('en');
  Intl.defaultLocale = 'en';
  screenSizeRequired();
  selectLanguage();
}

void screenSizeRequired() {
  while (stdout.terminalLines < 33 || stdout.terminalColumns < 156) {
    console.hideCursor();
    // final key = console.readKey();
    // if (key.isControl && key.controlChar == ControlCharacter.ctrlC) {
    //   disableAlternateScreen();
    //   exit(0);
    // }
    showError(printCentered("La taille de votre terminal est trop petite. Min height: 33 | width: 156 "), chalk.red);
  }
  terminalHeight = stdout.terminalLines;
  terminalWidth = stdout.terminalColumns;
}

List<String> getFrenchFlagLines({int height = 18, int stripeWidth = 18}) {
  final String blueStripe = chalk.onDarkBlue(' ' * stripeWidth);
  final String whiteStripe = chalk.bgWhite(' ' * stripeWidth);
  final String redStripe = chalk.onDarkRed(' ' * stripeWidth);

  final List<String> lines = [];
  final flagLine = blueStripe + whiteStripe + redStripe;

  for (var i = 0; i < height; i++) {
    lines.add(flagLine);
  }
  return lines;
}

String drawEnglishFlag() {
  final Chalk blue = chalk.onDarkBlue.darkBlue;
  final Chalk red = chalk.onDarkRed.darkRed;
  final Chalk white = chalk.bgWhite.white;
  final Chalk hide = chalk.hidden;

  String colorize(String line) {
    return line.split('').map((char) {
      switch (char) {
        case '8' || ";" || "a":
          return white(char);
        case '~' || '.' || '"' || "`":
          return red(char);
        case ':':
          return blue(char);
        case '|':
          return hide(char);
        default:
          return char;
      }
    }).join();
  }

  final lines = [
    "|~888a`~888a:::::::::::::::88......88:::::::::::::::;a8~\".a888~|",
    "|::::~8a.`~888a::::::::::::88......88::::::::::::;a8~\".a888~:::|",
    "|:::::::~8a.`~888a:::::::::88......88:::::::::;a8~\".a888~::::::|",
    "|::::::::::~8a.`~888a::::::88......88::::::;a8~\".a888~:::::::::|",
    "|:::::::::::::~8a.`~888a:::88......88:::;a8~\".a888~::::::::::::|",
    "|::::::::::::::::~8a.`~888a88......88;a8~\".a888~:::::::::::::::|",
    "|:::::::::::::::::::~8a.`~888......88~\".a888~::::::::::::::::::|",
    "|8888888888888888888888888888......8888888888888888888888888888|",
    "|..............................................................|",
    "|..............................................................|",
    "|8888888888888888888888888888......8888888888888888888888888888|",
    "|::::::::::::::::::a888~\".a88......888a.\"~8;:::::::::::::::::::|",
    "|:::::::::::::::a888~\".a8~:88......88~888a.\"~8;::::::::::::::::|",
    "|::::::::::::a888~\".a8~::::88......88:::~888a.\"~8;:::::::::::::|",
    "|:::::::::a888~\".a8~:::::::88......88::::::~888a.\"~8;::::::::::|",
    "|::::::a888~\".a8~::::::::::88......88:::::::::~888a.\"~8;:::::::|",
    "|:::a888~\".a8~:::::::::::::88......88::::::::::::~888a.\"~8;::::|",
    "|a888~\".a8~::::::::::::::::88......88:::::::::::::::~888a.\"~8;:|",
  ];

  return lines.map(colorize).join('\n');
}

void selectLanguage() async {
  final frenchLines = getFrenchFlagLines();
  final englishLines = drawEnglishFlag().split('\n');
  int language = 0;
  final spacing = '         ';

  void renderScreen() {
    console.clearScreen();
    setCursorPosition(terminalHeight * 0.12, 0);
    stdout.writeln(printCentered(chalk.deepPink("Sélectionnez votre langue !\n")));
    stdout.writeln(printCentered(chalk.deepPink("Select your language !\n\n\n")));
    final maxLines = [frenchLines.length, englishLines.length].reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxLines; i++) {
      final frenchLine = i < frenchLines.length ? frenchLines[i] : '';
      final englishLine = i < englishLines.length ? englishLines[i] : '';
      final combinedLine = frenchLine + spacing + englishLine;
      stdout.writeln(printCentered(combinedLine));
    }

    stdout.writeln();

    final frenchLabel = language == 0 ? chalk.onPurple.bold('Français') : chalk.grey('Français');
    final englishLabel = language == 1 ? chalk.onPurple.bold('English') : chalk.grey('English');

    setCursorPosition(terminalHeight * 0.85, ((((spacing.length) * 5) * terminalWidth) / 168));
    stdout.write(frenchLabel);
    setCursorPosition(terminalHeight * 0.85, ((((spacing.length) * 12.7) * terminalWidth) / 168));
    stdout.write(englishLabel);

    setCursorPosition((terminalHeight * 0.92), 0);
    stdout.writeln(chalk.greyX11("Touches disponibes : ◁ ▷\n⏎ pour sélectionner\nCtrl+C pour quitter"));
    setCursorPosition((terminalHeight * 0.92), terminalWidth - 24);
    stdout.writeln(chalk.greyX11("Available keys : ◁ ▷"));
    setCursorPosition((terminalHeight * 0.92) + 1, terminalWidth - 24);
    stdout.writeln(chalk.greyX11("⏎ to select"));
    setCursorPosition((terminalHeight * 0.92) + 2, terminalWidth - 24);
    stdout.writeln(chalk.greyX11("Ctrl+C to exit"));
  }

  renderScreen();

  while (true) {
    var key = console.readKey();
    if (key.controlChar == ControlCharacter.arrowRight || key.controlChar == ControlCharacter.arrowLeft) {
      language = (language + 1) % 2;
      renderScreen();
    }
    if (key.isControl && key.controlChar == ControlCharacter.ctrlC) {
      disableAlternateScreen();
      exit(0);
    }
    if (key.controlChar == ControlCharacter.enter) {
      Intl.defaultLocale = language == 0 ? 'fr' : 'en';
      words = language == 0 ? frWords : enWords;
      await newGame();
    }
  }
}

Future newGame() async {
  clearScreen();
  final availableLetters = await chooseLetters();
  setCursorPosition(4, 0);
  stdout.writeln(printCentered(Intl.message("MOTS TROUVÉS", name: "words_found")));
  drawBox(row: terminalHeight * 0.35, col: 100, startRow: terminalHeight * 0.15, color: chalk.green, centered: true);
  setCursorPosition((terminalHeight / 2), 0);
  drawBox(row: 3, col: 100, startRow: terminalHeight * 0.5, color: chalk.white, centered: true);
  setCursorPosition((terminalHeight * 0.65), 0);
  stdout.writeln(printCentered(chalk.lightPink(availableLetters.join(' '))));
  setCursorPosition(35, ((terminalWidth - 20) / 2) + 1);
  stdout.write('\x1b[?25h');
  inputWord = await readFilteredInput(availableLetters);
}

Future<String> readFilteredInput(List<String> availableLetters) async {
  final buffer = StringBuffer();
  final allowed = availableLetters.map((l) => l.toUpperCase()).toSet();

  renderLetters(availableLetters, buffer);
  while (true) {
    final key = console.readKey();
    if (key.char == '\n' || key.controlChar == ControlCharacter.enter) {
      final inputWord = buffer.toString();
      if (inputWord.isNotEmpty) {
        await verifyWord(inputWord, availableLetters, buffer);
        renderLetters(availableLetters, buffer);
      }
      continue;
    }
    final char = key.char.toUpperCase();
    if (allowed.contains(char) && RegExp(r'[A-Z]').hasMatch(char)) {
      buffer.write(char);
      stdout.write(char);
      renderLetters(availableLetters, buffer);
      clearErrorMessage(buffer);
    }
    if (key.controlChar == ControlCharacter.backspace && buffer.isNotEmpty) {
      final text = buffer.toString();
      buffer.clear();
      buffer.write(text.substring(0, text.length - 1));
      stdout.write('\b \b');
      renderLetters(availableLetters, buffer);
      clearErrorMessage(buffer);
    }
    if (key.controlChar == ControlCharacter.ctrlC) {
      disableAlternateScreen();
      exit(0);
    }
  }
}

void renderLetters(List<String> availableLetters, StringBuffer buffer) {
  stdout.write('\x1b[?25l');
  setCursorPosition((terminalHeight * 0.65), 0);
  stdout.write('\x1b[2K\r');
  String line = '';
  for (int i = 0; i < availableLetters.length; i++) {
    if (buffer.toString().contains(availableLetters[i])) {
      line += chalk.grey('${availableLetters[i]} ');
    } else {
      line += chalk.lightPink('${availableLetters[i]} ');
    }
  }
  stdout.writeln(printCentered(line));
  stdout.write('\x1b[?25h');
  setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1 + buffer.length);
}

void showError(String message, Chalk color) {
  showErrorMsg = true;
  setCursorPosition((terminalHeight * 0.6), 0);
  stdout.writeln(printCentered(color(message)));
}

void clearErrorMessage(StringBuffer buffer) {
  if (showErrorMsg) {
    setCursorPosition((terminalHeight * 0.55), 0);
    stdout.write('\x1b[2K\r');
    showErrorMsg = false;
    setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1 + buffer.length);
  }
}

Future<void> verifyWord(String inputWord, List<String> availableLetters, StringBuffer buffer) async {
  if (wordsFound.contains(inputWord)) {
    showError(
      Intl.message("Le mot '$inputWord' a déjà été trouvé.", name: "already_found", args: [inputWord]),
      chalk.greenYellow,
    );
    return;
  }
  bool exist = await isValidWord(inputWord);
  if (exist) {
    final lettersMap = lettersToDico(availableLetters);
    final wordMap = lettersToDico(inputWord.split(''));
    final wordsPossible = await findPossibleWord(availableLetters);
    if (isIncluded(wordMap, lettersMap) && wordsPossible.contains(inputWord.toUpperCase())) {
      stdout.writeln(
        chalk.hotPink(
          Intl.message("Bravo ! Le mot '$inputWord' est un des plus longs.", name: "win_congrats", args: []),
        ),
      );
    } else if (isIncluded(wordMap, lettersMap) && !wordsPossible.contains(inputWord.toUpperCase())) {
      wordsFound.add(inputWord);
      buffer.clear();
      setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1);
      for (int i = 0; i < inputWord.length; i++) {
        stdout.write(' ');
      }
      setCursorPosition(7, ((terminalWidth - 20) / 2) + 1);
      stdout.write('\x1b[2K\r');
      for (int i = 0; i < wordsFound.length; i++) {
        setCursorPosition(7 + i, ((terminalWidth - 20) / 2) + 1);
        stdout.write(chalk.green(wordsFound[i]));
      }
    }
  } else {
    showError(
      Intl.message("Le mot '$inputWord' n'existe pas dans le dictionnaire.", name: "invalid_word", args: []),
      chalk.deepPink,
    );
  }
}

List<String> letters = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];

List<String> vowels = ['A', 'E', 'I', 'O', 'U'];

List<String> word = [];
List<Map<dynamic, dynamic>> dictionary = [];

int nbVowels = 0;

// TODO randomize letters
Future<List<String>> chooseLetters() async {
  List<String> availableLetters = [];
  int nbLetters = 7;

  while (availableLetters.length < nbLetters) {
    String letter = letters[Random().nextInt(letters.length)];
    if (availableLetters.contains(letter)) continue;
    availableLetters.add(letter);
    if (vowels.contains(letter)) {
      nbVowels++;
    }
  }

  if (nbVowels < 2) {
    availableLetters[Random().nextInt(availableLetters.length)] = vowels[Random().nextInt(vowels.length)];
  }

  return availableLetters;
}

Future<bool> isValidWord(String word) async {
  for (String w in words) {
    if (w.trim().toUpperCase() == word.toUpperCase()) {
      return true;
    }
  }
  return false;
}

Map lettersToDico(List<String> letters) {
  var result = {};
  for (String letter in letters) {
    if (result.containsKey(letter)) {
      result[letter] += 1;
    } else {
      result[letter] = 1;
    }
  }
  return result;
}

bool isIncluded(Map word1, Map word2) {
  for (var entry in word1.entries) {
    var key = entry.key;
    var value = entry.value;

    if (word2.containsKey(key)) {
      if (value > word2[key]) {
        return false;
      }
    } else {
      return false;
    }
  }
  return true;
}

Future<List<String>> findPossibleWord(List<String> availableLetters) async {
  dictionary.clear();

  for (String word in words) {
    word = word.trim().toUpperCase();
    var dico = {};
    for (int i = 0; i < word.length; i++) {
      String letter = word[i];
      if (dico.containsKey(letter)) {
        dico[letter] += 1;
      } else {
        dico[letter] = 1;
      }
    }
    dictionary.add(dico);
  }
  Map lettersMap = lettersToDico(availableLetters);
  List<String> wordsPossible = [];

  for (int i = 0; i < words.length; i++) {
    String word = words[i].trim().toUpperCase();

    if (isIncluded(dictionary[i], lettersMap)) {
      wordsPossible.add(word);
    }
  }

  if (wordsPossible.isEmpty) return [];

  int maxLength = wordsPossible.map((word) => word.length).reduce((max, length) => length > max ? length : max);

  return wordsPossible.where((word) => word.length == maxLength).toList();
}
