import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Login/login_screen.dart';
import '../Courses/courses_page.dart';
import '../Whiteboard/whiteboard_page.dart';
import '../Home/home_page.dart';
import '../Gamification/games_hub.dart';
import '../../widgets/constant_bottom_nav_bar.dart';
import '../../widgets/constant_app_bar.dart';
import 'my_account_page.dart';

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
  final Color primaryColor = const Color(0xFF1A5F7A);
  final Color secondaryColor = const Color(0xFF2E8BC0);
  final Color accentColor = const Color(0xFFFFB703);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color textColor = const Color(0xFF333333);

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
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: ConstantAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: const AssetImage('assets/default_avatar.png'),
                backgroundColor: secondaryColor,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAccountPage()),
                  );
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
      bottomNavigationBar: ConstantBottomNavBar(
        currentIndex: 4, // Profile is selected
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Courses()));
              break;
            case 1:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WhiteboardPage()));
              break;
            case 2:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              break;
            case 3:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => GamesHub()));
              break;
            case 4:
              // Already on Profile page
              break;
          }
        },
      ),
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
      trailing: Icon(Icons.chevron_right, color: secondaryColor),
      onTap: onTap,
    );
  }
}
