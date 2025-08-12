# Letters Game
>For the English version, see the file [here](README.md).

Un jeu en terminal dans lequel vous devez former le mot le plus long possible à partir de lettres proposées.  
Ce jeu est disponible en français et en anglais. La langue du jeu vous sera demandée à chaque lancement du jeu.

https://github.com/user-attachments/assets/03cd88fd-af62-4949-94c7-c6dfe04d6a5c


## Règles
Le jeu vous propose des lettres. Grâce à ces lettres, vous devrez former un des mots les plus longs possible.

Vous pouvez utiliser une lettre autant de fois qu'elle est proposée.
Par défaut, le jeu vous proposera systématiquement **9 lettres** avec **au minimum 2 voyelles**.

> Vous pouvez modifier le nombre de lettres et de voyelles minimums dans les paramètres du jeu.

Le jeu utilise des dictionnaires de mots trouvés sur Internet. Il se peut donc qu'il y ait des abréviations, d'ancien mots ou des erreurs.  
En français, le dictionnaire ne prend pas en compte les mots avec des accents.

Le jeu n'utilise aucune API et **ne nécessite pas de connexion à Internet**.

## Installation
Sur **Linux** et **macOS** il vous suffit de télécharger l'exécutable correspondant à votre architecture depuis la page des [releases](https://github.com/el2zay/letters_game/releases). Et de l'exécuter dans un terminal.

Il se peut que vous ayez besoin de donner les droits d'exécution à l'exécutable avec la commande :
```bash
chmod +x <nom_du_fichier>
```

Le jeu ne stocke **aucune donnée**.  
Pour désinstaller le jeu, il vous suffit de supprimer l'exécutable.

<b>Vous pouvez aussi compiler le jeu vous-même</b> (fonctionne sur Linux, macOS et Windows) :
1. Installez [Dart SDK](https://dart.dev/get-dart).
2. Clonez le dépôt :
    ```bash
    git clone https://github.com/el2zay/letters_game
    ```
3. Accédez au dossier du projet :
    ```bash
    cd letters_game
    ```
<!-- 4. Téléchargez les dictionnaires [ici](https://files.bassinecorp.fr/letters_game/) et placez les dans `lib/resources`. -->

4. Compilez le projet :
    ```bash
    dart compile exe lib/letters_game.dart -o letters_game
    ```
5. Exécutez le jeu :
    ```bash
    ./letters_game
    ```

## Terminal supporté 
### 🍏 macOS
- Terminal ❌
- Hyper ✅ (recommandé)
- iTerm2 ✅
- Ghostty ✅
- Warp ✅

### 🐧 Linux (testé sur ZorinOS)
- GNOME Terminal ✅
- Hyper ✅ 
- Terminator ✅
- Alacritty ✅
