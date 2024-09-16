import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/constant_app_bar.dart';
import '../../widgets/constant_bottom_nav_bar.dart';
import 'Word Guess/word_guess.dart';
import '../Courses/courses_page.dart';
import '../Whiteboard/whiteboard_page.dart';
import '../Profile/student_profile_screen.dart';
import '../Home/home_page.dart';

class GamesHub extends StatefulWidget {
  @override
  _GamesHubState createState() => _GamesHubState();
}

class _GamesHubState extends State<GamesHub> {
  final Color primaryColor = Color(0xFF1A5F7A);
  final Color secondaryColor = Color(0xFF2E8BC0);
  final Color accentColor = Color(0xFFFFB703);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color textColor = Color(0xFF333333);

  int _selectedIndex = 3; // Assuming Games Hub is the 4th item in the nav bar

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Courses()));
          break;
        case 1:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => WhiteboardPage()));
          break;
        case 2:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          break;
        case 4:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => StudentProfileScreen()));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantAppBar(title: 'Games Hub'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a Game',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGameCard(
                      context,
                      'Word Guess',
                      Icons.spellcheck,
                      'Guess the word and improve your vocabulary!',
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WordGuessingGame())),
                    ),
                    _buildGameCard(
                      context,
                      'Sign Language Matcher',
                      Icons.sign_language,
                      'Match Gujarati words with the correct sign language gestures.',
                      () {}, // TODO: Implement Sign Language Matcher game
                    ),
                    _buildGameCard(
                      context,
                      'Lip Reading Challenge',
                      Icons.face,
                      'Guess the Gujarati word being mouthed in the video.',
                      () {}, // TODO: Implement Lip Reading Challenge game
                    ),
                    _buildGameCard(
                      context,
                      'Picture-Word Association',
                      Icons.image,
                      'Match images with their correct Gujarati words.',
                      () {}, // TODO: Implement Picture-Word Association game
                    ),
                    _buildGameCard(
                      context,
                      'Sentence Builder',
                      Icons.format_align_left,
                      'Arrange words to form correct Gujarati sentences.',
                      () {}, // TODO: Implement Sentence Builder game
                    ),
                    _buildGameCard(
                      context,
                      'Fingerspelling Practice',
                      Icons.fingerprint,
                      'Practice Gujarati fingerspelling alphabet.',
                      () {}, // TODO: Implement Fingerspelling Practice game
                    ),
                    _buildGameCard(
                      context,
                      'Visual Vocabulary Quiz',
                      Icons.quiz,
                      'Match images with their written Gujarati forms.',
                      () {}, // TODO: Implement Visual Vocabulary Quiz game
                    ),
                    _buildGameCard(
                      context,
                      'Sign Language Story Time',
                      Icons.book,
                      'Watch a story in Gujarati sign language and answer questions.',
                      () {}, // TODO: Implement Sign Language Story Time game
                    ),
                    _buildGameCard(
                      context,
                      'Emoji Translator',
                      Icons.emoji_emotions,
                      'Translate emoji sequences into Gujarati words or phrases.',
                      () {}, // TODO: Implement Emoji Translator game
                    ),
                    _buildGameCard(
                      context,
                      'Silent Video Captioning',
                      Icons.closed_caption,
                      'Choose the correct Gujarati caption for silent video clips.',
                      () {}, // TODO: Implement Silent Video Captioning game
                    ),
                    _buildGameCard(
                      context,
                      'Gesture-to-Text',
                      Icons.gesture,
                      'Match gestures to Gujarati words or phrases using your camera.',
                      () {}, // TODO: Implement Gesture-to-Text game
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ConstantBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, IconData icon,
      String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                secondaryColor.withOpacity(0.1),
                primaryColor.withOpacity(0.1)
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: primaryColor),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Expanded(
                child: Text(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
