import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Mathematics/module_video_logic.dart'; // Ensure that chapter_detail.dart is correctly imported

class SciencePage extends StatelessWidget {
  final List<Map<String, String>> chapters = [
    {
      'title': 'Chapter 1: Introduction to Science',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_1', // Replace with actual video ID
    },
    {
      'title': 'Chapter 2: States of Matter',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_2', // Replace with actual video ID
    },
    {
      'title': 'Chapter 3: The Human Digestive System',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_3', // Replace with actual video ID
    },
    {
      'title': 'Chapter 4: The Solar System',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_4', // Replace with actual video ID
    },
    {
      'title': 'Chapter 5: Chemical Reactions',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_5', // Replace with actual video ID
    },
    {
      'title': 'Chapter 6: Ecosystems and Food Chains',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_6', // Replace with actual video ID
    },
    {
      'title': 'Chapter 7: Force and Motion',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_7', // Replace with actual video ID
    },
    {
      'title': 'Chapter 8: Sound and Light',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_8', // Replace with actual video ID
    },
    {
      'title': 'Chapter 9: The Periodic Table',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_9', // Replace with actual video ID
    },
    {
      'title': 'Chapter 10: Electricity and Magnetism',
      'videoId': 'VIDEO_ID_FOR_CHAPTER_10', // Replace with actual video ID
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  size: 40, color: Colors.deepPurpleAccent),
                              SizedBox(width: 20),
                              Text(
                                chapters[index]['title']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
