import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Mathematics/module_video_logic.dart'; // Ensure that chapter_detail.dart is correctly imported

class SciencePage extends StatelessWidget {
  final List<Map<String, String>> chapters = [
    {
      'title': 'Introduction to Science: Chapter 1',
      'videoId': 'nIjAEHi-6HU',
    },
    {
      'title': 'States of Matter: Chapter 2',
      'videoId': '6Lb8PCw6vcc',
    },
    {
      'title': 'The Human Digestive System: Chapter 3',
      'videoId': 'Y_7WiIi_uTk',
    },
    {
      'title': 'The Solar System: Chapter 4',
      'videoId': 'LljUaUMMCdg',
    },
    {
      'title': 'Chemical Reactions: Chapter 5',
      'videoId': 'nLG-B3e-pP0',
    },
    {
      'title': 'Ecosystems and Food Chains: Chapter 6',
      'videoId': 'pwnPigO4MuM',
    },
    {
      'title': 'Force and Motion: Chapter 7',
      'videoId': 'RDxX3fWFvzY',
    },
    {
      'title': 'Sound and Light: Chapter 8',
      'videoId': 'zMC0dTOVeUA',
    },
    {
      'title': 'The Periodic Table: Chapter 9',
      'videoId': 'MjFpCgFgt1A',
    },
  ];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF80D0C7), Color(0xFF13547A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Science",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailPage(
                            title: chapters[index]['title']!,
                            videoId: chapters[index]['videoId']!,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Icon(Icons.play_circle_fill,
                                size: 40, color: Colors.deepPurpleAccent),
                            SizedBox(width: 20),
                            Expanded(  // Added to prevent text overflow
                              child: Text(
                                chapters[index]['title']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis, // Trims overflowed text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
