import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../module_video_logic.dart'; // We'll reuse this for video playback
import '../../../widgets/constant_app_bar.dart';

class SciencePage extends StatelessWidget {
  final List<Map<String, String>> chapters = [
    {
      'title': 'Ch-1 Food Where does it come from',
      'videoId': 'nIjAEHi-6HU',
    },
    {
      'title': 'Ch-2 Components of Food with QR',
      'videoId': '6Lb8PCw6vcc',
    },
    {
      'title': 'Ch-3 Fiber',
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

  SciencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConstantAppBar(title: 'Science'),
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
