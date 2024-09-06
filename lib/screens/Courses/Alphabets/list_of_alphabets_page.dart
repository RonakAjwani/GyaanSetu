import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyaan_setu/screens/Courses/Alphabets/whiteboard_alphabet.dart';

// AlphabetsPage: Displays a grid of Gujarati alphabets
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alphabets',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 200, 145, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: alphabets.length,
          itemBuilder: (context, index) {
            return _buildAlphabetCard(
              context,
              alphabets[index]['alphabet']!,
              alphabets[index]['transliteration']!,
            );
          },
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              alphabet,
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 183, 111, 255),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '[$transliteration]',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
