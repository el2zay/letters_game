# Letters Game  
> Pour la version française, consultez le fichier [README_fr.md].

A terminal-based game in which you must build the longest possible word from a set of letters.  
The game is available in both French and English; you choose the language each time you start it.

## Rules
The game presents you with several letters. With these letters you must create one of the longest words you can.

You may reuse the same letter more than once, but ideally no more times than it appears in the set.  
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

## Supported terminal
### 🍏 macOS
- Terminal ❌
- Hyper ✅ (recommended)
- iTerm2 ✅
- Ghostty ✅
- Warp ✅
