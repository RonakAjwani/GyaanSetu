import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';
import '../Profile/student_profile_screen.dart';
import '../Gamification/games_hub.dart';
import '../Courses/courses_page.dart';
import '../Whiteboard/whiteboard_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/constant_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  bool _isEnglishToGujarati = true;
  String _outputText = '';
  final translator = GoogleTranslator();
  late AnimationController _controller;
  bool _isTranslatorExpanded = false;
  String _userName = 'User';

  // Color scheme
  final Color primaryColor = Color(0xFF1A5F7A);
  final Color secondaryColor = Color(0xFF2E8BC0);
  final Color accentColor = Color(0xFFFFB703);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color textColor = Color(0xFF333333);
  final Color lightTextColor = Color(0xFF757575);
  final Color errorColor = Color(0xFFD62828);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _controller.forward();
    _fetchUserName();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _userName = userData['fullName'] ?? 'User';
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Courses()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WhiteboardPage()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GamesHub()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StudentProfileScreen()));
        break;
    }
  }

  void _translateText(String text) async {
    final translation = _isEnglishToGujarati
        ? await translator.translate(text, from: 'en', to: 'gu')
        : await translator.translate(text, from: 'gu', to: 'en');
    setState(() {
      _outputText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  _buildHeader(),
                  SizedBox(height: 24),
                  _buildWelcomeCard(),
                  SizedBox(height: 24),
                  _buildQuickTranslator(),
                  SizedBox(height: 24),
                  _buildFeatureCards(),
                ],
              ),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/app_logo.svg',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 12),
            Text(
              'GyaanSetu',
              style: GoogleFonts.roboto(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.notifications, color: primaryColor),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notifications coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, secondaryColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'profile_image',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          image: AssetImage('assets/images/user_profile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          _userName,
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Your Progress',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2500,
                percent: 0.8,
                center: Text(
                  "80.0%",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: accentColor,
                backgroundColor: Colors.white.withOpacity(0.3),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Courses()));
                },
                child: Text('Continue Learning'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: primaryColor,
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTranslator() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isTranslatorExpanded = !_isTranslatorExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.translate, color: primaryColor),
                      SizedBox(width: 12),
                      Text(
                        'Quick Translator',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isTranslatorExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            if (_isTranslatorExpanded) ...[
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: _isEnglishToGujarati
                      ? 'Enter English text'
                      : 'Enter Gujarati text',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: _translateText,
              ),
              SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _outputText.isEmpty ? Colors.transparent : primaryColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  _outputText.isEmpty
                      ? 'Translation will appear here'
                      : _outputText,
                  style: GoogleFonts.roboto(color: textColor, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEnglishToGujarati = !_isEnglishToGujarati;
                    });
                  },
                  icon: Icon(Icons.swap_horiz, color: Colors.white),
                  label: Text(
                    _isEnglishToGujarati
                        ? 'Switch to Gujarati'
                        : 'Switch to English',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildFeatureCard('Courses', Icons.book, () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Courses()));
            }),
            _buildFeatureCard('Whiteboard', Icons.edit, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WhiteboardPage()));
            }),
            _buildFeatureCard('Games', Icons.games, () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => GamesHub()));
            }),
            _buildFeatureCard('Profile', Icons.person, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentProfileScreen()));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                secondaryColor.withOpacity(0.1),
                primaryColor.withOpacity(0.1)
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: primaryColor),
              SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
