import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gyaan_setu/screens/Courses/Numbers/whiteboard_numbers.dart';
import '../../../widgets/constant_app_bar.dart';

class NumbersPage extends StatelessWidget {
  final List<Map<String, String>> numbers = [
    {"number": "૦", "text": "Zero"},
    {"number": "૧", "text": "1"},
    {"number": "૨", "text": "2"},
    {"number": "૩", "text": "3"},
    {"number": "૪", "text": "4"},
    {"number": "૫", "text": "5"},
    {"number": "૬", "text": "6"},
    {"number": "૭", "text": "7"},
    {"number": "૮", "text": "8"},
    {"number": "૯", "text": "9"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConstantAppBar(title: 'Numbers'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return _buildNumberCard(
              context,
              numbers[index]['number']!,
              numbers[index]['text']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNumberCard(BuildContext context, String number, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NumberDetailPage(
              number: number,
              text: text,
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
              number,
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E8BC0),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '[$text]',
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
