import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../module_video_logic.dart';
import '../../../widgets/constant_app_bar.dart';

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
  ];

  const MathematicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConstantAppBar(title: 'Mathematics'),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            return _buildChapterCard(context, chapters[index]);
          },
        ),
      ),
    );
  }

  Widget _buildChapterCard(BuildContext context, Map<String, String> chapter) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.play_circle_filled,
            color: Color(0xFF2E8BC0), size: 40),
        title: Text(
          chapter['title']!,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChapterDetailPage(
                title: chapter['title']!,
                videoId: chapter['videoId']!,
              ),
            ),
          );
        },
      ),
    );
  }
}
