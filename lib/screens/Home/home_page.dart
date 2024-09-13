import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';
import '../Profile/student_profile_screen.dart';
import '../Gamification/word_guess.dart';
import '../Courses/courses_page.dart';
import '../Whiteboard/whiteboard_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
  late Animation<double> _animation;
  bool _isTranslatorExpanded = false;

  // Updated color scheme
  final Color primaryColor = Color(0xFF8E44AD); // Deep purple
  final Color secondaryColor = Color(0xFF9B59B6); // Medium purple
  final Color accentColor = Color(0xFFAF7AC5); // Light purple
  final Color backgroundColor = Color(0xFFF4ECF7); // Very light purple
  final Color textColor = Color(0xFF4A235A); // Dark purple

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WordGuessingGame()));
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'GyaanSetu',
          style: GoogleFonts.nunito(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: primaryColor),
            onPressed: () {
              // Handle notification button press
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'profile_image',
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/user_profile.png'),
                    radius: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, User!',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Continue your learning journey',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Current Course Progress',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return LinearPercentIndicator(
                  animation: true,
                  animationDuration: 1500,
                  lineHeight: 20.0,
                  percent: _animation.value * 0.6,
                  center: Text(
                    "${(_animation.value * 60).toInt()}%",
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: primaryColor,
                  backgroundColor: accentColor.withOpacity(0.2),
                );
              },
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Resume course action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Resuming your course...')),
                  );
                },
                icon: Icon(Icons.play_arrow, color: Colors.white),
                label: Text(
                  'Resume Course',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTranslator() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  Text(
                    'Quick Translator',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
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
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onChanged: _translateText,
              ),
              SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
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
                  style: GoogleFonts.nunito(color: textColor),
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
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          style: GoogleFonts.nunito(
            fontSize: 18,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WordGuessingGame()));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: primaryColor),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.nunito(
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Whiteboard'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Game'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: primaryColor,
      unselectedItemColor: textColor.withOpacity(0.5),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
      onTap: _onItemTapped,
    );
  }
}
