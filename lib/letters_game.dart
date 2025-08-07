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
int letterCount = 0;
int nbVowels = 2;
int nbLetters = 9;

void main() async {
  enableAlternateScreen();
  console.hideCursor();
  ProcessSignal.sigint.watch().listen((_) {
    disableAlternateScreen();
    exit(0);
  });
  await initializeMessages('en');
  Intl.defaultLocale = 'en';
  if (terminalHeight < 33 || terminalWidth < 156) screenSizeRequired();
  selectLanguage();
}

void screenSizeRequired() {
  // Le booléen permet de stopper la boucle quand la condition est remplie.
  while (stdout.terminalLines < 33 || stdout.terminalColumns < 156) {
    console.hideCursor();
    showError(
      printCentered(
        Intl.message(
          "La taille de votre terminal est trop petite. Min height: 33 | width: 156 ",
          name: "terminal_size_error",
        ),
      ),
      chalk.red,
      0.5,
    );
  }

  terminalHeight = stdout.terminalLines;
  terminalWidth = stdout.terminalColumns;
  console.clearScreen();

  while (true) {
    showError(
      printCentered(Intl.message("Appuyez sur n'importe quelle touche pour continuer.", name: "press_any_key")),
      chalk.cyanBright,
      0.5,
    );
    console.hideCursor();
    final key = console.readKey();
    if (key.controlChar == ControlCharacter.ctrlC) {
      disableAlternateScreen();
      exit(0);
    } else {
      terminalHeight = stdout.terminalLines;
      terminalWidth = stdout.terminalColumns;
      break;
    }
  }
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
      return;
    }
  }
}

void selectMenu(int select, List<String> menuList) {
  setCursorPosition(terminalHeight * 0.75, 0);

  for (int i = 0; i < menuList.length; i++) {
    stdout.writeln(printCentered(select == i ? chalk.bgMagenta(menuList[i]) : menuList[i]));
    stdout.writeln();
  }

  if (select == -1) {
    setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2));
    stdout.write(' ');
  }
}

void howToPlay() async {
  clearScreen();
  console.hideCursor();
  setCursorPosition(terminalHeight * 0.1, 0);
  stdout.writeln(
    printCentered("""
                         
 ____        _           
|  _ \\ _   _| | ___  ___ 
| |_) | | | | |/ _ \\/ __|
|  _ <| |_| | |  __/\\__ \\
|_| \\_\\\\__,_|_|\\___||___/

"""),
  );

  stdout.writeln(
    Intl.message(
      """Le jeu vous propose des lettres. Grâce à ces lettres, vous devrez former un des mots les plus longs possible. 
Vous pouvez utiliser une lettre autant de fois qu'elle est proposée.
Par défaut, le jeu vous proposera systématiquement 9 lettres avec au minimum 2 voyelles. Vous pouvez modifier cela dans les paramètres.

Le jeu utilise des dictionnaires de mots trouvés sur Internet. Il se peut donc qu’il y ait des abréviations, d’ancien mots ou des erreurs. 
En français, le dictionnaire ne prend pas en compte les mots avec des accents.
Vous pouvez retrouver les dictionnaires sur le site suivant : https://files.bassinecorp.fr/letters_game/

Le jeu n’utilise aucune API et ne nécessite pas d’une connexion à Internet.


""",
      name: "how_to_play_description",
    ),
  );
  stdout.writeln(
    printCentered(
      chalk.deepPink(Intl.message("Appuyez sur n'importe quelle touche pour continuer.", name: "press_any_key")),
    ),
  );
  setCursorPosition(terminalHeight * 0.95, 0);
  stdout.writeln(
    printCentered(chalk.cyanBright(Intl.message("Développé avec <3 à Paris par Elie.", name: "developed_by"))),
  );

  final key = console.readKey();

  if (key.controlChar == ControlCharacter.ctrlC) {
    disableAlternateScreen();
    exit(0);
  } else {
    await newGame();
    return;
  }
}

Future settings() async {
  clearScreen();
  int select = 0;
  bool done = false;

  final columnPosition1 = (Intl.defaultLocale == 'en' ? (terminalWidth - 23) / 2 : (terminalWidth - 28) / 2).round();
  final columnPosition2 = (Intl.defaultLocale == 'en' ? (terminalWidth - 21) / 2 : (terminalWidth - 30) / 2).round();

  void renderScreen() {
    clearScreen();
    setCursorPosition(terminalHeight * 0.1, 0);
    stdout.writeln(printCentered(chalk.deepPink(Intl.defaultLocale == 'en' ? "Settings" : "Paramètres")));

    setCursorPosition(terminalHeight * 0.3, columnPosition1);
    stdout.writeln(Intl.message("Nombre de lettres minimum : ", name: "min_letters_count"));
    setCursorPosition(terminalHeight * 0.3 + 1, columnPosition1);
    if (select == 0) {
      stdout.write(chalk.bgMagenta(" > $nbLetters < "));
    } else {
      stdout.write(chalk.greyX11(Intl.message("Actuellement : $nbLetters", name: "currently", args: [nbLetters])));
    }

    setCursorPosition(terminalHeight * 0.6, columnPosition2);
    stdout.writeln(Intl.message("Nombre de voyelles minimum :", name: "min_vowels_count"));
    setCursorPosition(terminalHeight * 0.6 + 1, columnPosition2);
    if (select == 1) {
      stdout.write(chalk.bgMagenta(" > $nbVowels < "));
    } else {
      stdout.write(chalk.greyX11(Intl.message("Actuellement : $nbVowels", name: "currently", args: [nbVowels])));
    }

    setCursorPosition(terminalHeight * 0.9, 0);
    stdout.writeln(chalk.greyX11(Intl.message("Q pour quitter", name: "quit_settings")));
  }

  renderScreen();

  while (!done) {
    final key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowUp) {
      select = (select - 1) < 0 ? 1 : select - 1;
      renderScreen();
    }
    if (key.controlChar == ControlCharacter.arrowDown) {
      select = (select + 1) > 1 ? 0 : select + 1;
      renderScreen();
    }
    if (key.controlChar == ControlCharacter.ctrlC) {
      disableAlternateScreen();
      exit(0);
    }
    if (key.char.toLowerCase() == 'q') {
      await newGame();
      return;
    }
    if (key.controlChar == ControlCharacter.enter) {
      setCursorPosition(
        select == 0 ? (terminalHeight * 0.3 + 2) : (terminalHeight * 0.6 + 2),
        select == 0 ? columnPosition1 : columnPosition2,
      );
      stdout.write(chalk.cyan(Intl.message("Entrez une valeur : ", name: "enter_value")));
      String? line = stdin.readLineSync();
      final input = int.tryParse(line ?? "");
      if (select == 0) {
        if (input != null && input >= 6 && input <= 20) {
          nbLetters = input;
        } else {
          showError(
            Intl.message("Le nombre de lettres doit être compris entre 6 et 20.", name: "invalid_min_letters_count"),
            chalk.red,
            0.42,
          );
          sleep(Duration(seconds: 2));
        }
      } else if (select == 1) {
        if (input != null && input >= 2 && input <= nbLetters - 2) {
          nbVowels = input;
        } else {
          showError(
            Intl.message(
              "Le nombre de voyelles doit être compris entre 2 et ${nbLetters - 2}.",
              name: "invalid_min_vowels_count",
            ),
            chalk.red,
            0.72,
          );
          sleep(Duration(seconds: 2));
        }
      }
      renderScreen();
    }
  }
}

Future newGame() async {
  wordsFound.clear();
  inputWord = "";
  showErrorMsg = false;
  clearScreen();
  final availableLetters = await chooseLetters();
  // print(await findPossibleWord(availableLetters));
  setCursorPosition(4, 0);
  stdout.writeln(printCentered(Intl.message("MOTS TROUVÉS", name: "words_found")));
  drawBox(row: terminalHeight * 0.35, col: 100, startRow: terminalHeight * 0.15, color: chalk.green, centered: true);
  setCursorPosition((terminalHeight / 2), 0);
  drawBox(row: 3, col: 100, startRow: terminalHeight * 0.5, color: chalk.white, centered: true);
  setCursorPosition((terminalHeight * 0.65), 0);
  stdout.writeln(printCentered(chalk.lightPink(availableLetters.join(' '))));
  selectMenu(-1, [
    Intl.message("1. Comment jouer ?", name: "how_to_play"),
    Intl.message("2. Menu principal ", name: "main_menu"),
    Intl.message("3. Paramètres     ", name: "settings"),
    Intl.message("4. Quitter le jeu ", name: "quit"),
  ]);

  stdout.write('\x1b[?25h');
  inputWord = await readFilteredInput(availableLetters);
}

Future<String> readFilteredInput(List<String> availableLetters) async {
  final buffer = StringBuffer();
  int select = -1;

  renderLetters(availableLetters, buffer);
  while (true) {
    final key = console.readKey();
    if (key.char == '\n' || key.controlChar == ControlCharacter.enter) {
      if (select == -1) {
        final inputWord = buffer.toString();
        if (inputWord.isNotEmpty) {
          await verifyWord(inputWord, availableLetters, buffer);
          renderLetters(availableLetters, buffer);
        }
        continue;
      }
      if (select == 0) {
        howToPlay();
        return '';
      }
      if (select == 1) {
        selectLanguage();
        return '';
      }
      if (select == 2) {
        await settings();
        return '';
      }
      if (select == 3) {
        disableAlternateScreen();
        exit(0);
      }
    }
    final char = key.char.toUpperCase();
    if (select == -1 && RegExp(r'[A-Z]').hasMatch(char)) {
      Map<String, int> used = {};
      for (var l in buffer.toString().split('')) {
        used[l] = (used[l] ?? 0) + 1;
      }

      Map<String, int> available = {};
      for (var l in availableLetters) {
        available[l] = (available[l] ?? 0) + 1;
      }

      if ((used[char] ?? 0) < (available[char] ?? 0)) {
        buffer.write(char);
        stdout.write(char);
        renderLetters(availableLetters, buffer);
        clearErrorMessage(buffer);
      }
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
    if (key.controlChar == ControlCharacter.arrowUp) {
      if (select == -1) {
        setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1);
        stdout.write('\x1b[2K\r');
        buffer.clear();
        setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1 + buffer.length);
      }
      select = (select - 1) < -1 ? 3 : (select - 1);

      selectMenu(select, [
        Intl.message("1. Comment jouer ?", name: "how_to_play"),
        Intl.message("2. Menu principal ", name: "main_menu"),
        Intl.message("3. Paramètres     ", name: "settings"),
        Intl.message("4. Quitter le jeu ", name: "quit"),
      ]);
    }
    if (key.controlChar == ControlCharacter.arrowDown) {
      if (select == -1) {
        setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1);
        stdout.write('\x1b[2K\r');
        buffer.clear();
        setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1 + buffer.length);
      }
      select = (select + 1) > 3 ? -1 : (select + 1);
      selectMenu(select, [
        Intl.message("1. Comment jouer ?", name: "how_to_play"),
        Intl.message("2. Menu principal ", name: "main_menu"),
        Intl.message("3. Paramètres     ", name: "settings"),
        Intl.message("4. Quitter le jeu ", name: "quit"),
      ]);
    }
  }
}

void renderLetters(List<String> availableLetters, StringBuffer buffer) {
  stdout.write('\x1b[?25l');
  setCursorPosition((terminalHeight * 0.65), 0);
  stdout.write('\x1b[2K\r');
  String line = '';

  Map<String, int> used = {};
  for (var l in buffer.toString().split('')) {
    used[l] = (used[l] ?? 0) + 1;
  }

  Map<String, int> displayCount = {};
  for (var letter in availableLetters) {
    displayCount[letter] = (displayCount[letter] ?? 0) + 1;
    if ((used[letter] ?? 0) >= displayCount[letter]!) {
      line += chalk.grey('$letter ');
    } else {
      line += chalk.lightPink('$letter ');
    }
  }
  stdout.writeln(printCentered(line));
  stdout.write('\x1b[?25h');
  setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1 + buffer.length);
}

void showError(String message, Chalk color, [double ratio = 0.6]) {
  showErrorMsg = true;
  setCursorPosition((terminalHeight * ratio), 0);
  stdout.writeln(printCentered(color(message)));
}

void clearErrorMessage(StringBuffer buffer) {
  if (showErrorMsg) {
    setCursorPosition((terminalHeight * 0.6), 0);
    stdout.write('\x1b[2K\r');
    showErrorMsg = false;
    setCursorPosition(terminalHeight * 0.53, ((terminalWidth - 20) / 2) + 1 + buffer.length);
  }
}

Future winCongratulation(String inputWord) async {
  int select = 0;
  clearScreen();
  showError(
    Intl.message("Bravo ! Le mot '$inputWord' est un des plus longs.", name: "win_congrats", args: [inputWord]),
    chalk.green,
    0.5,
  );

  while (true) {
    selectMenu(select, [
      Intl.message("1. Rejouer       ", name: "replay"),
      Intl.defaultLocale == 'en' ? "2. Quit  " : "2. Quitter le jeu",
    ]);
    final key = console.readKey();
    if (key.controlChar == ControlCharacter.ctrlC) {
      disableAlternateScreen();
      exit(0);
    }
    if (key.controlChar == ControlCharacter.arrowUp) {
      select = (select - 1) < 0 ? 1 : select - 1;
    } else if (key.controlChar == ControlCharacter.arrowDown) {
      select = (select + 1) > 1 ? 0 : select + 1;
    } else if (key.controlChar == ControlCharacter.enter) {
      if (select == 0) {
        await newGame();
        return;
      } else if (select == 1) {
        disableAlternateScreen();
        exit(0);
      }
    }
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
      await winCongratulation(inputWord);
      return;
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

Future<List<String>> chooseLetters() async {
  List<String> availableLetters = [];

  for (int i = 0; i < nbVowels; i++) {
    String vowel = vowels[Random().nextInt(vowels.length)];
    availableLetters.add(vowel);
  }

  for (int i = availableLetters.length; i < nbLetters; i++) {
    String letter = letters[Random().nextInt(letters.length)];
    availableLetters.add(letter);
  }

  availableLetters.shuffle();

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
