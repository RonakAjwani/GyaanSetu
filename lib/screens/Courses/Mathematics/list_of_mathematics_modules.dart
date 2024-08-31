import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'module_video_logic.dart'; // Ensure this import is correct

class MathematicsPage extends StatelessWidget {
  final List<Map<String, String>> chapters = [
    {
      'title': 'Chapter 1: Introduction to Algebra',
      'videoId': 'FujZJe2sCgY',
    },
    {
      'title': 'Chapter 2: Basic Operations',
      'videoId': 'PLWwALcsb529M8_Q-2UawTbkl9WWrtnPkN&index=2',
    },
    // Add more chapters here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2A4FF), Color(0xFFE7CFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Mathematics",
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(Icons.play_circle_fill,
                                  size: 40, color: Colors.purpleAccent),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  chapters[index]['title']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
