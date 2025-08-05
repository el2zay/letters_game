// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
        "words_found": MessageLookupByLibrary.simpleMessage("WORDS FOUND"),
        "win_congrats": MessageLookupByLibrary.simpleMessage("Congratulations! The word is one of the longest."),
        "invalid_word": MessageLookupByLibrary.simpleMessage("The word does not exist in the dictionary."),
        "available_letters": MessageLookupByLibrary.simpleMessage("Here are the available letters:"),
        "enter_word": MessageLookupByLibrary.simpleMessage("Enter a word:"),
        "already_found": (word) => "The word $word has already been found.",
        "not_longest": MessageLookupByLibrary.simpleMessage("The word is correct but not the longest possible."),
        "not_buildable": MessageLookupByLibrary.simpleMessage("The word cannot be formed with the available letters."),
        "terminal_size_error":
            MessageLookupByLibrary.simpleMessage("The size of your terminal is too small. Min height: 33 | width: 156"),
        "how_to_play_description": MessageLookupByLibrary.simpleMessage(
            "The game gives you letters. Use these letters to form one of the longest words possible.\nYou can use the same letter several times, but it's best to use it as many times as the game suggests. \nBy default, the game will always suggest 9 letters with a minimum of 2 vowels.\n\nThe game uses dictionaries of words found on the Internet. As a result, there may be abbreviations, old words or errors. \nIn French, the dictionary does not take into account words with accents.\nDictionaries can be found at https://files.bassinecorp.fr/letters_game/\n\nThe game uses no API and requires no Internet connection.\n\n"),
        "press_any_key": MessageLookupByLibrary.simpleMessage("Press any key to continue."),
        "developed_by": MessageLookupByLibrary.simpleMessage("Developed with <3 in Paris by Elie."),
        "how_to_play": MessageLookupByLibrary.simpleMessage("1. How to play? "),
        "main_menu": MessageLookupByLibrary.simpleMessage("2. Main menu    "),
        "settings": MessageLookupByLibrary.simpleMessage("3. Settings     "),
        "min_letters_count": MessageLookupByLibrary.simpleMessage("Minimum letters count: "),
        "currently": (count) => "Currently : $count",
        "min_vowels_count": MessageLookupByLibrary.simpleMessage("Minimum vowels count: "),
        "invalid_number": (input) => "The input '$input' is not a valid number.",
        "quit_settings": MessageLookupByLibrary.simpleMessage("Press Q to quit."),
        "quit": MessageLookupByLibrary.simpleMessage("4. Quit          "),
        "enter_value": MessageLookupByLibrary.simpleMessage("Enter a value: "),
        "invalid_min_letters_count":
            MessageLookupByLibrary.simpleMessage("The number of letters must be between 6 and 20."),
        "invalid_min_vowels_count": MessageLookupByLibrary.simpleMessage(
            "The number of vowels must be between 2 and the number of letters minus 2.")
      };
}
