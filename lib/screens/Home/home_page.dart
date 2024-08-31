import 'package:flutter/material.dart';
import 'package:translator/translator.dart'; // Add this import for translation
import '../Profile/student_profile_screen.dart';
import '../Gamification/word_guess.dart'; // Import the game1.dart file
import '../Courses/courses_page.dart';
import '../Whiteboard/whiteboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 2; // Default to home tab
  bool _isEnglishToGujarati = true; // Determines the language direction
  String _outputText = ''; // Holds the translated text
  final translator = GoogleTranslator(); // Initialize the translator

  late AnimationController _animationController;
  late Animation<double> _fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start animation when page loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentProfileScreen()),
        );
      } else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WordGuessingGame()), // Navigate to game1.dart
        );
      } else if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Courses()), // Navigate to Courses page
        );
      } else if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WhiteboardPage()), // Navigate to Whiteboard page
        );
      }
    });
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'GyaanSetu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notification button press
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: kToolbarHeight + 20.0), // Pull everything down slightly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Welcome Section
                  _buildWelcomeSection(),

                  // Translator Section
                  _buildQuickAccessSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWelcomeSection() {
    return FadeTransition(
      opacity: _fadeInFadeOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage:
                  const AssetImage('assets/images/user_profile.png'),
              radius: 40,
              backgroundColor: Colors.grey,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent,
                  ),
                  child: const Icon(Icons.check_circle,
                      color: Colors.lightBlue, size: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome Back, [User Name]!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Continue your journey of knowledge',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 5),
            const Text(
              '60% of your current course completed',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Resume course action
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  const Text('Resume Course', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 15),
          _buildTranslatorInputBox(),
          const SizedBox(height: 15),
          _buildTranslationOutputBox(),
          const SizedBox(height: 15),
          _buildLanguageSwitch(),
        ],
      ),
    );
  }

  Widget _buildTranslatorInputBox() {
    return TextField(
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.translate, color: Color.fromARGB(60, 20, 0, 0)),
        filled: true,
        fillColor: Colors.white, // Set background color
        hintText: _isEnglishToGujarati
            ? 'Enter text in English'
            : 'Enter text in Gujarati',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
      ),
      onChanged: (text) {
        _translateText(text); // Perform translation on text change
      },
    );
  }

  Widget _buildTranslationOutputBox() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.blueAccent, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        _outputText.isEmpty ? 'Translation will appear here' : _outputText,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLanguageSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEnglishToGujarati =
                  !_isEnglishToGujarati; // Toggle language direction
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            _isEnglishToGujarati
                ? 'Switch to Gujarati to English'
                : 'Switch to English to Gujarati',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brush),
          label: 'Whiteboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset),
          label: 'Game',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white, // Selected item color
      unselectedItemColor: Colors.white70, // Unselected item color
      backgroundColor: Colors.black, // Background color
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed, // Label visibility
    );
  }
}
