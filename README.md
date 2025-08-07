# Letters Game  
> Pour la version française, consultez le fichier [ici](https://github.com/el2zay/letters_game/blob/main/README_fr.md).

A terminal-based game in which you must build the longest possible word from a set of letters.  
The game is available in both French and English; you choose the language each time you start it.

https://github.com/user-attachments/assets/03cd88fd-af62-4949-94c7-c6dfe04d6a5c


## Rules
The game presents you with several letters. With these letters you must create one of the longest words you can.

You can use a letter as many times as it is shown.
By default the game supplies **9 letters** containing **at least 2 vowels**.

> You can adjust the total number of letters and the minimum vowel count in the game settings.

The word lists come from open-source dictionaries found online, so abbreviations, archaic forms, or errors may appear.  
In french, accented characters are ignored.

The game calls no external API and **does not require an Internet connection**.

## Installation
On **Linux** and **macOS** simply download the executable that matches your CPU architecture from the project’s [releases](https://github.com/el2zay/letters_game/releases) page, then run it in a terminal.

If needed, grant execute permission with:  
```bash
chmod +x <executable_name>
```

The game stores **no data**.  
To uninstall it, just delete the executable.

<b>You can also compile the game yourself</b> (works on Linux, macOS, and Windows):
1. Install the [Dart SDK](https://dart.dev/get-dart).
2. Clone the repository:
    ```bash
    git clone https://github.com/el2zay/letters_game
    ```
3. Navigate to the project folder:
    ```bash
    cd letters_game
    ```
4. Download the dictionaries [here](https://files.bassinecorp.fr/letters_game/) and place them in `lib/resources`.
5. Compile the project:
    ```bash
    dart compile exe lib/letters_game.dart -o letters_game
    ```
6. Run the game:
    ```bash
    ./letters_game
    ```

## Supported terminal
### 🍏 macOS
- Terminal ❌
- Hyper ✅ (recommended)
- iTerm2 ✅
- Ghostty ✅
- Warp ✅

### 🐧 Linux (tested on ZorinOS)
- GNOME Terminal ✅
- Hyper ✅
- Terminator ✅
- Alacritty ✅
