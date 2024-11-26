import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'whiteboard_alphabet.dart';

class AlphabetsPage extends StatelessWidget {
  final List<Map<String, String>> alphabets = [
    {"alphabet": "ક", "transliteration": "ka"},
    {"alphabet": "ખ", "transliteration": "kha"},
    {"alphabet": "ગ", "transliteration": "ga"},
    {"alphabet": "ઘ", "transliteration": "gha"},
    {"alphabet": "ઙ", "transliteration": "nga"},
    {"alphabet": "ચ", "transliteration": "ca"},
    {"alphabet": "છ", "transliteration": "cha"},
    {"alphabet": "જ", "transliteration": "ja"},
    {"alphabet": "ઝ", "transliteration": "jha"},
    {"alphabet": "ઞ", "transliteration": "nya"},
    {"alphabet": "ટ", "transliteration": "tta"},
    {"alphabet": "ઠ", "transliteration": "ttha"},
    {"alphabet": "ડ", "transliteration": "dda"},
    {"alphabet": "ઢ", "transliteration": "ddha"},
    {"alphabet": "ણ", "transliteration": "nna"},
    {"alphabet": "ત", "transliteration": "ta"},
    {"alphabet": "થ", "transliteration": "tha"},
    {"alphabet": "દ", "transliteration": "da"},
    {"alphabet": "ધ", "transliteration": "dha"},
    {"alphabet": "ન", "transliteration": "na"},
    {"alphabet": "પ", "transliteration": "pa"},
    {"alphabet": "ફ", "transliteration": "pha"},
    {"alphabet": "બ", "transliteration": "ba"},
    {"alphabet": "ભ", "transliteration": "bha"},
    {"alphabet": "મ", "transliteration": "ma"},
    {"alphabet": "ય", "transliteration": "ya"},
    {"alphabet": "ર", "transliteration": "ra"},
    {"alphabet": "લ", "transliteration": "la"},
    {"alphabet": "ળ", "transliteration": "lla"},
    {"alphabet": "વ", "transliteration": "va"},
    {"alphabet": "શ", "transliteration": "sha"},
    {"alphabet": "ષ", "transliteration": "ssa"},
    {"alphabet": "સ", "transliteration": "sa"},
    {"alphabet": "હ", "transliteration": "ha"},
  ];

  final Color primaryColor = const Color(0xFF1A5F7A);
  final Color secondaryColor = const Color(0xFF2E8BC0);
  final Color accentColor = const Color(0xFFFFB703);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color textColor = const Color(0xFF333333);

  AlphabetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gujarati Alphabets',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Changed to white for better visibility
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white), // Added this line to change back button color
        elevation: 0, // Added elevation for better separation from the body
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimationLimiter(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: alphabets.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _buildAlphabetCard(
                        context,
                        alphabets[index]['alphabet']!,
                        alphabets[index]['transliteration']!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetCard(
      BuildContext context, String alphabet, String transliteration) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignLanguagePage(
              alphabet: alphabet,
              transliteration: transliteration,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              alphabet,
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '[$transliteration]',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
