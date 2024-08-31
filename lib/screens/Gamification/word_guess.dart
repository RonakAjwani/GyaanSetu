import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WordGuessingGame());
}

class WordGuessingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Guessing Game',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Map<String, List<String>> words = {
    'gu': ["ગાય", "મકાન", "પાનખર"],
    'en': ["COW", "HOUSE", "MONSOON"]
  };
  final List<String> extraLetters = ["લ", "ન", "હ", "ર", "જ"];
  final List<String> extraLettersEn = ["L", "N", "H", "R", "J", "A", "E"];

  String selectedLanguage = 'gu'; // Default language
  int currentLevel = 0;
  int gems = 0;
  List<String> selectedLetters = [];
  List<String> originalLetters = [];
  bool isHintUsed = false;
  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    if (currentLevel < words[selectedLanguage]!.length) {
      setState(() {
        String currentWord = words[selectedLanguage]![currentLevel];
        originalLetters = _shuffleWithExtraLetters(currentWord);
        selectedLetters =
            List<String>.filled(currentWord.length, '', growable: false);
        isHintUsed = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  List<String> _shuffleWithExtraLetters(String word) {
    List<String> letters = word.split('');
    List<String> extra =
        selectedLanguage == 'gu' ? extraLetters : extraLettersEn;
    letters.addAll(_getRandomExtraLetters(letters.length, extra));
    letters.shuffle();
    return letters;
  }

  List<String> _getRandomExtraLetters(int count, List<String> extraLetters) {
    final random = Random();
    List<String> randomLetters = [];
    while (randomLetters.length < count) {
      String randomLetter = extraLetters[random.nextInt(extraLetters.length)];
      if (!randomLetters.contains(randomLetter)) {
        randomLetters.add(randomLetter);
      }
    }
    return randomLetters;
  }

  void onLetterSelected(int index) {
    setState(() {
      if (selectedLetters.contains('') && originalLetters[index].isNotEmpty) {
        int emptyIndex = selectedLetters.indexOf('');
        selectedLetters[emptyIndex] = originalLetters[index];
        originalLetters[index] = '';
      }
    });
  }

  void onRemoveSelectedLetter(int index) {
    setState(() {
      if (selectedLetters[index].isNotEmpty) {
        originalLetters[originalLetters.indexOf('')] = selectedLetters[index];
        selectedLetters[index] = '';
      }
    });
  }

  void onSubmit() {
    String guessedWord = selectedLetters.join();
    if (guessedWord == words[selectedLanguage]![currentLevel]) {
      setState(() {
        currentLevel++;
        gems += isHintUsed ? 5 : 10;
        leaderboard.add({'level': currentLevel, 'score': gems});
        resetGame();
      });
    } else {
      _showSnackBar('Incorrect! Try again.', Colors.red);
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You completed all levels.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentLevel = 0;
                  gems = 0;
                  leaderboard.clear();
                  resetGame();
                });
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void useHint() {
    if (!isHintUsed && gems >= 5) {
      setState(() {
        isHintUsed = true;
        gems -= 5;
        String correctWord = words[selectedLanguage]![currentLevel];
        selectedLetters[0] = correctWord[0];
        _showSnackBar('Hint used! First letter revealed.', Colors.orange);
      });
    } else {
      _showSnackBar('Not enough gems or hint already used.', Colors.grey);
    }
  }

  void navigateToLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderboardScreen(leaderboard: leaderboard),
      ),
    );
  }

  void showDailyWord() {
    final random = Random();
    String dailyWord = words[selectedLanguage]![
        random.nextInt(words[selectedLanguage]!.length)];
    _showSnackBar('Daily Word: $dailyWord', Colors.blueAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Guessing Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            onPressed: useHint,
            tooltip: 'Use Hint (5 Gems)',
          ),
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: navigateToLeaderboard,
            tooltip: 'Leaderboard',
          ),
          IconButton(
            icon: Icon(Icons.event),
            onPressed: showDailyWord,
            tooltip: 'Daily Word',
          ),
          DropdownButton<String>(
            value: selectedLanguage,
            items: [
              DropdownMenuItem(value: 'gu', child: Text('Gujarati')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                resetGame();
              });
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level: ${currentLevel + 1}',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Gems: $gems',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7)
                ],
              ),
              child: Center(
                child: Text(
                  'Sign Language Description Here',
                  style: TextStyle(
                      color: Colors.purple[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: selectedLetters.map((letter) {
                int index = selectedLetters.indexOf(letter);
                return GestureDetector(
                  onTap: () => onRemoveSelectedLetter(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          letter.isNotEmpty ? Colors.purple : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: originalLetters.map((letter) {
                int index = originalLetters.indexOf(letter);
                return GestureDetector(
                  onTap: () => onLetterSelected(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: letter.isNotEmpty
                          ? Colors.deepPurple
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onSubmit,
              icon: Icon(Icons.check),
              label: Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;

  LeaderboardScreen({required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Level ${leaderboard[index]['level']}'),
                trailing: Text('Score: ${leaderboard[index]['score']}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
