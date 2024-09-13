import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Update this import path to where your login page is actually located
import '../Login/login_screen.dart';
import '../Courses/courses_page.dart';
import '../Whiteboard/whiteboard_page.dart';
import '../Home/home_page.dart';
import '../Gamification/word_guess.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _username = '';
  String _email = '';

  // Color scheme
  final Color primaryColor = const Color(0xFF8E44AD);
  final Color accentColor = const Color(0xFFAF7AC5);
  final Color backgroundColor = const Color(0xFFF4ECF7);
  final Color textColor = const Color(0xFF4A235A);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _username = userData.get('username') as String? ?? 'User';
        _email = user.email ?? '';
      });
    }
  }

  Future<void> _logOut() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Make sure LoginScreen is the correct class name
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: GoogleFonts.nunito(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/default_avatar.png'),
                backgroundColor: accentColor,
              ),
              const SizedBox(height: 16),
              Text(
                _username,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _email,
                style: GoogleFonts.nunito(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 24),
              _buildProfileOption(
                icon: Icons.person,
                title: "My Account",
                onTap: () {
                  // Navigate to My Account page
                },
              ),
              _buildProfileOption(
                icon: Icons.privacy_tip,
                title: "Privacy",
                onTap: () {
                  // Handle Privacy tap
                },
              ),
              _buildProfileOption(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  // Handle Settings tap
                },
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: "Help & Support",
                onTap: () {
                  // Handle Help & Support tap
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _logOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Log Out",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Version 1.0.0",
                style: GoogleFonts.nunito(
                    fontSize: 14, color: textColor.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryColor, size: 28),
      title: Text(
        title,
        style: GoogleFonts.nunito(fontSize: 18, color: textColor),
      ),
      trailing: Icon(Icons.chevron_right, color: accentColor),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Whiteboard'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Game'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 4, // Profile is selected
      selectedItemColor: primaryColor,
      unselectedItemColor: textColor.withOpacity(0.5),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Courses())); // Removed const
            break;
          case 1:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => WhiteboardPage())); // Removed const
            break;
          case 2:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage())); // Removed const
            break;
          case 3:
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => WordGuessingGame())); // Removed const
            break;
          case 4:
            // Already on Profile page
            break;
        }
      },
    );
  }
}
