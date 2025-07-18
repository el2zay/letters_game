import 'dart:io';
import 'dart:math' show Random;

import 'package:chalkdart/chalk.dart';
import 'package:letters_game/resources/fr_dictionnary.dart';
import 'package:letters_game/utils/alternate_screen.dart';
import 'package:letters_game/utils/style_utils.dart';

// Détecter la width du terminal
final int terminalWidth = stdout.terminalColumns;
// Détecter la height du terminal
final int terminalHeight = stdout.terminalLines;

void main() {
  enableAlternateScreen();
  ProcessSignal.sigint.watch().listen((_) {
    disableAlternateScreen();
    exit(0);
  });

  selectLanguage();
  // game();
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

void selectLanguage() {
  final frenchLines = getFrenchFlagLines();
  final englishLines = drawEnglishFlag().split('\n');

  final spacing = '         ';

  stdout.writeln(printCentered(chalk.bold.deepPink("Select your language !\n\n\n")));

  final maxLines = [frenchLines.length, englishLines.length].reduce((a, b) => a > b ? a : b);

  for (int i = 0; i < maxLines; i++) {
    final frenchLine = i < frenchLines.length ? frenchLines[i] : '';
    final englishLine = i < englishLines.length ? englishLines[i] : '';
    final combinedLine = frenchLine + spacing + englishLine;
    stdout.writeln(printCentered(combinedLine));
  }
}

void game() async {
  stdout.writeln(chalk.pink("Here are the available letters : "));
  final availableLetters = chooseLetters();
  final wordsPossible = await findPossibleWord(availableLetters);
  stdout.writeln(chalk.lightPink(availableLetters.join(' ')));
  bool won = false;
  bool inProgress = false;

  while (!won) {
    if (!inProgress) {
      stdout.writeln(chalk.pink("Enter a world : "));
      String? inputWord = stdin.readLineSync()?.toUpperCase();

      if (inputWord != null && inputWord.isNotEmpty) {
        bool exist = await isValidWord(inputWord);

        if (exist) {
          final lettersMap = lettersToDico(availableLetters);
          final wordMap = lettersToDico(inputWord.split(''));

          if (isIncluded(wordMap, lettersMap) && !wordsPossible.contains(inputWord)) {
            stdout.writeln(
              chalk.hotPink("Congrats ! The word $inputWord is one of the longest words."),
            );
            won = true;
          } else if (isIncluded(wordMap, lettersMap) &&
              !wordsPossible.contains(inputWord.toUpperCase())) {
            stdout.writeln(
              chalk.hotPink("The word'$inputWord' is correct but not the longest possible."),
            );
            inProgress = false;
          } else {
            stdout.writeln(
              chalk.hotPink("The word '$inputWord is not formed with the available letters"),
            );
            inProgress = false;
          }
        } else {
          inProgress = false;
          stdout.writeln(chalk.deepPink("The word '$inputWord' does not exist in the dictionary"));
        }
      } else {
        inProgress = false;
        stdout.writeln(chalk.hotPink("No words entered. Please try again."));
      }
    }
  }
}

// TODO faire plusieurs fonction qui correspondrons à des screens
// 1 Sélectionner le langage : Drapeau 🇫🇷 et 🇺🇸/🇬🇧 en ASCII
// 2 Select : Commencer à jouer, Comment jouer, Changer de langue
// 3 Jeu : demande une taille minimale pour jouer

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
List<Map<dynamic, dynamic>> dictionnary = [];

int nbVowels = 0;

List<String> chooseLetters() {
  List<String> word = [];
  for (int i = 0; i < 9; i++) {
    word.add(letters[Random().nextInt(letters.length)]);
    if (vowels.contains(word[i])) {
      nbVowels++;
    }
  }

  while (nbVowels < 2) {
    word.clear();
    chooseLetters();
  }
  return word;
}

Future<bool> isValidWord(String word) async {
  for (String w in frWords) {
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
  dictionnary.clear();

  for (String word in frWords) {
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
    dictionnary.add(dico);
  }
  Map lettersMap = lettersToDico(availableLetters);
  List<String> wordsPossible = [];

  for (int i = 0; i < frWords.length; i++) {
    String word = frWords[i].trim().toUpperCase();

    if (isIncluded(dictionnary[i], lettersMap)) {
      wordsPossible.add(word);
    }
  }

  if (wordsPossible.isEmpty) return [];

  int maxLength = wordsPossible
      .map((word) => word.length)
      .reduce((max, length) => length > max ? length : max);

  return wordsPossible.where((word) => word.length == maxLength).toList();
}
