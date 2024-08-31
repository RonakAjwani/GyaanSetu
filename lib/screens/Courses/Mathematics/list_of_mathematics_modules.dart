import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'module_video_logic.dart'; // Ensure this import is correct

class MathematicsPage extends StatelessWidget {
  final List<Map<String, String>> chapters = [
    {
      'title': 'Chapter 1: Introduction to Shapes And Space',
      'videoId': 'BGBS-CFn3YA',
    },
    {
      'title': 'Chapter 2: Question on Shapes and Space',
      'videoId': 't3JPr4VLafA',
    },
    {
      'title': 'Chapter 3: Numbers from 1 to 9',
      'videoId': '27kD7WunkHI',
    },
    {
      'title': 'Chapter 4: Exercise on 1 to 9',
      'videoId': 'uO-_ZGeXSXQ',
    },
    {
      'title': 'Chapter 6: Introduction to Shapes',
      'videoId': 't3JPr4VLafA',
    },
    {
      'title': 'Chapter 7: Introduction to Addition',
      'videoId': '8jywPyKp364',
    },
    {
      'title': 'Chapter 8: Exercise on Addition',
      'videoId': 'WR6LXNOYwUU',
    },
    
    {
      'title': 'Chapter 9: Introduction to Subtraction',
      'videoId': 'IAhrwiLCiFI',
    },
    {
      'title': 'Chapter 10: Exercise on Subtraction',
      'videoId': 'K49siiPUjU4',
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
