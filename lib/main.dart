import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(WordGuessGame());

class WordGuessGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.jpg', // Replace with your logo asset
                height: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                'Word Guess Game',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WordGuessHomePage()),
                  );
                },
                child: const Text(
                  'Play',
                  style: TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordGuessHomePage extends StatefulWidget {
  @override
  _WordGuessHomePageState createState() => _WordGuessHomePageState();
}

class _WordGuessHomePageState extends State<WordGuessHomePage> {
  final List<String> words = [
    'FLUTTER',
    'PROGRAMMING',
    'DEVELOPER',
    'GAME',
    'CODE',
    'JAVA',
    'PYTHON',
    'GUESS',
    'MOBILE'
  ];

  final Map<String, String> wordImages = {
    'FLUTTER': 'assets/flutter.jpg',
    'PROGRAMMING': 'assets/programming.jpg',
    'DEVELOPER': 'assets/developer.jpg',
    'GAME': 'assets/game.jpg',
    'CODE': 'assets/code.jpg',
    'JAVA': 'assets/java.jpg',
    'PYTHON': 'assets/python.jpg',
    'GUESS': 'assets/guess.jpg',
    'MOBILE': 'assets/mobile.jpg',
  };

  late String currentWord;
  Set<String> guessedLetters = {};
  int wrongGuesses = 0;
  final int maxWrongGuesses = 6;
  int score = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    currentWord = (words..shuffle()).first;
    guessedLetters.clear();
    wrongGuesses = 0;
    provideHints();
  }

  void provideHints() {
    int hintsToProvide = currentWord.length <= 5
        ? 1
        : (currentWord.length >= 6 && currentWord.length <= 8 ? 2 : 3);

    Random random = Random();
    Set<String> hintLetters = {};
    while (hintLetters.length < hintsToProvide) {
      hintLetters.add(currentWord[random.nextInt(currentWord.length)]);
    }

    guessedLetters.addAll(hintLetters);
  }

  void handleGuess(String letter) {
    setState(() {
      guessedLetters.add(letter.toUpperCase());
      if (!currentWord.contains(letter.toUpperCase())) {
        wrongGuesses++;
      }
    });
  }

  String get displayWord {
    return currentWord.split('').map((letter) {
      return guessedLetters.contains(letter) ? letter : '_';
    }).join(' ');
  }

  bool get hasWon => !displayWord.contains('_');
  bool get hasLost => wrongGuesses >= maxWrongGuesses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 159, 123, 221),
        title: const Text('Word Guess Game', style: TextStyle(fontSize: 24)),
        actions: [
          // Add logo on the right side of the AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.jpg', // Replace with your logo asset
              height: 40,
            ),
          ),
        ],
        centerTitle: true, // Keep title centered
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 18, 77, 161), const Color.fromARGB(255, 77, 116, 212)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Display the score at the top
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (wordImages[currentWord] != null)
              Image.asset(
                wordImages[currentWord]!,
                height: 150,
              ),
            const SizedBox(height: 20),
            const Text(
              'Word to Guess:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // Display the word in boxes (instead of dashes)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentWord.split('').map((letter) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    color: guessedLetters.contains(letter) ? Colors.white : Colors.transparent,
                  ),
                  child: Text(
                    guessedLetters.contains(letter) ? letter : '',
                    style: TextStyle(
                      fontSize: 28,
                      color: guessedLetters.contains(letter) ? Colors.black : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (hasWon || hasLost)
              Column(
                children: [
                  if (hasLost)
                    Column(
                      children: [
                        const Text(
                          'You LOST! 😢',
                          style: TextStyle(fontSize: 24, color: Colors.red),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              score = 0; // Reset score on loss
                              resetGame();
                            });
                          },
                          child: const Text('Play Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                  if (hasWon)
                    Column(
                      children: [
                        const Text(
                          'You WON! 🎉',
                          style: TextStyle(fontSize: 24, color: Colors.green),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              score += 5; // Increase score by 5 after win
                              resetGame(); // Automatically go to the next word
                            });
                          },
                          child: const Text('Next Word'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            if (!hasWon && !hasLost)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                  bool isGuessed = guessedLetters.contains(letter);
                  bool isCorrect = currentWord.contains(letter) && isGuessed;

                  return ElevatedButton(
                    onPressed: isGuessed
                        ? null // Disable button if the letter is already guessed
                        : () => handleGuess(letter),
                    child: Text(letter),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: isGuessed
                            ? (isCorrect ? Colors.green : Colors.red) // Green for correct, red for incorrect
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      backgroundColor: isGuessed
                          ? (isCorrect ? Colors.green.shade200 : Colors.red.shade200)
                          : Colors.purple.shade300,
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
