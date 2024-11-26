import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../widgets/constant_app_bar.dart';
import '../../widgets/constant_bottom_nav_bar.dart';
import 'Mathematics/list_of_mathematics_modules.dart';
import 'Science/list_of_science_modules.dart';
import 'Alphabets/list_of_alphabets_page.dart';
import 'Numbers/list_of_numbers.dart';
import '../Whiteboard/whiteboard_page.dart';
import '../Home/home_page.dart';
import '../Gamification/games_hub.dart';
import '../Profile/student_profile_screen.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  int _selectedIndex = 0; // Set to 0 for Courses page

  // Color scheme
  final Color primaryColor = const Color(0xFF1A5F7A);
  final Color secondaryColor = const Color(0xFF2E8BC0);
  final Color accentColor = const Color(0xFFFFB703);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color textColor = const Color(0xFF333333);
  final Color lightTextColor = const Color(0xFF757575);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Already on Courses page, no navigation needed
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WhiteboardPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => GamesHub()));
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const StudentProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const ConstantAppBar(title: 'Courses'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Courses',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        _buildCourseCard(
                          title: 'Alphabets',
                          icon: Icons.abc,
                          color: secondaryColor,
                          progress: 0.7,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlphabetsPage()),
                          ),
                        ),
                        _buildCourseCard(
                          title: 'Numbers',
                          icon: Icons.numbers,
                          color: secondaryColor,
                          progress: 0.5,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NumbersPage()),
                          ),
                        ),
                        _buildCourseCard(
                          title: 'Mathematics',
                          icon: Icons.calculate,
                          color: secondaryColor,
                          progress: 0.3,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MathematicsPage()),
                          ),
                        ),
                        _buildCourseCard(
                          title: 'Science',
                          icon: Icons.science,
                          color: secondaryColor,
                          progress: 0.1,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SciencePage()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ConstantBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required IconData icon,
    required Color color,
    required double progress,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.2)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: color),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: lightTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
