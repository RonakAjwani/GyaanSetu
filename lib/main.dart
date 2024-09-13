import 'package:flutter/material.dart';
import 'screens/SignUp/signup_screen.dart'; // Ensure these paths are correct
import 'screens/Login/login_screen.dart';
import 'screens/Profile/student_profile_screen.dart';
import 'screens/Profile/my_account_page.dart'; // Import the MyAccountPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GyaanSetu',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) =>
            const WelcomePage(), // Welcome page as the initial screen
        '/login': (context) => LoginScreen(), // Define route for login screen
        '/signup': (context) =>
            SignUpScreen(), // Define route for signup screen
        '/studentProfile': (context) =>
            StudentProfileScreen(), // Route for student profile
        '/account': (context) => MyAccountPage(), // Route for account page
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/gyaansetu.logo.png', // Ensure correct path for logo
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'GyaanSetu',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text('Signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
