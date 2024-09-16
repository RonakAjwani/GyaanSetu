import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/constant_app_bar.dart';

class WordGuessingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Guessing Game',
      theme: ThemeData(
        primaryColor: Color(0xFF1A5F7A),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFF2E8BC0),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
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
  final Color primaryColor = Color(0xFF1A5F7A);
  final Color secondaryColor = Color(0xFF2E8BC0);
  final Color accentColor = Color(0xFFFFB703);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color textColor = Color(0xFF333333);

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

  void showDailyWord() {
    final random = Random();
    String dailyWord = words[selectedLanguage]![
        random.nextInt(words[selectedLanguage]!.length)];
    _showSnackBar('Daily Word: $dailyWord', Colors.blueAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantAppBar(title: 'Word Guessing Game'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level: ${currentLevel + 1}',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                Text('Gems: $gems',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3)
                ],
              ),
              child: Center(
                child: Text(
                  'Sign Language Description Here',
                  style: GoogleFonts.roboto(
                      color: primaryColor,
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
                          letter.isNotEmpty ? primaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      letter,
                      style: GoogleFonts.roboto(
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
                      color:
                          letter.isNotEmpty ? secondaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      letter,
                      style:
                          GoogleFonts.roboto(fontSize: 30, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onSubmit,
              icon: Icon(Icons.check, color: Colors.white),
              label: Text('Submit', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: GoogleFonts.roboto(fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: useHint,
                  icon: Icon(Icons.lightbulb, color: primaryColor),
                  label:
                      Text('Use Hint', style: TextStyle(color: primaryColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    textStyle: GoogleFonts.roboto(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: showDailyWord,
                  icon: Icon(Icons.calendar_today, color: primaryColor),
                  label:
                      Text('Daily Word', style: TextStyle(color: primaryColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    textStyle: GoogleFonts.roboto(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
