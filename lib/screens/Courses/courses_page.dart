import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoIcons
import 'Mathematics/list_of_mathematics_modules.dart'; // Import your MathematicsPage
import 'Science/list_of_science_modules.dart'; // Import your SciencePage
import 'Alphabets/list_of_alphabets_page.dart'; // Import your AlphabetsPage
import 'Numbers/list_of_numbers.dart'; // Import your NumbersPage
import '../Whiteboard/whiteboard_page.dart'; // Import WhiteboardPage
import '../Profile/student_profile_screen.dart'; // Import StudentProfileScreen
import '../Gamification/word_guess.dart'; // Import Game1 (Word Guessing Game)
import '../Home/home_page.dart'; // Import HomePage

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  int _selectedIndex = 0; // Default to courses tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (index) {
      case 0:
        // Stay on Courses page
        break;
      case 1:
        // Navigate to Whiteboard page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WhiteboardPage()),
        );
        break;
      case 2:
        // Navigate to Home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 3:
        // Navigate to Game page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WordGuessingGame()),
        );
        break;
      case 4:
        // Navigate to Profile page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 204, 162, 246), Color.fromARGB(255, 226, 204, 248)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section (Welcome Message and Flag Icon)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Alan",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Start Your Learnings!",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/flag.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // "Your Lessons" Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Your Lessons",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Course Cards Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildCourseCard(
                        icon: Icons.book,
                        title: "Alphabets",
                        progress: 0.74,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlphabetsPage(),
                            ),
                          );
                        },
                      ),
                      _buildCourseCard(
                        icon: Icons.confirmation_number,
                        title: "Numbers",
                        progress: 0.74,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NumbersPage(),
                            ),
                          );
                        },
                      ),
                      _buildCourseCard(
                        icon: Icons.calculate,
                        title: "Mathematics",
                        progress: 0.45,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MathematicsPage(),
                            ),
                          );
                        },
                      ),
                      _buildCourseCard(
                        icon: Icons.science,
                        title: "Science",
                        progress: 0.32,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SciencePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white, // Color for selected item
        unselectedItemColor: Colors.white70, // Color for unselected items
        backgroundColor: Colors.black, // Background color
        type: BottomNavigationBarType.fixed, // Keep labels visible
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Courses",
          ),
          BottomNavigationBarItem(
            icon:
                Icon(CupertinoIcons.bars), // Use CupertinoIcons for Whiteboard
            label: "Whiteboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: "Game",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      {required IconData icon,
      required String title,
      required double progress,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
