import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import '../SignUp/signup_screen.dart'; // Import the SignUpScreen
import 'forgot_password_screen.dart'; // Import the ForgotPasswordScreen
import '../Home/home_page.dart'; // Import the StudentProfileScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 186, 117, 255), // Solid color instead of gradient
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80), // Spacing from status bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi!\nWelcome",
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Please log in to continue",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.lock_open, color: Colors.white, size: 30),
                  ],
                ),
                SizedBox(height: 40),
                _buildTextField("Email or Phone Number", Icons.email),
                SizedBox(height: 20),
                _buildPasswordTextField("Password", Icons.lock),
                SizedBox(height: 5),
                _buildRememberMe(),
                SizedBox(height: 30),
                _buildLoginButton(),
                SizedBox(height: 30),
                _buildStudentLoginButton(), // Add this line
                SizedBox(height: 30),
                _buildForgotPasswordText(context),
                SizedBox(height: 20),
                _buildOrDivider(),
                SizedBox(height: 20),
                _buildGoogleLoginButton(),
                SizedBox(height: 30),
                _buildSignUpText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildPasswordTextField(String hintText, IconData icon) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        suffixIcon: Icon(Icons.visibility_off, color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: Colors.white,
              checkColor: Colors.blue,
            ),
            Text(
              "Remember Me",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Handle forgot password logic
          },
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle login logic here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // White background for button
        padding: EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      child: Center(
        child: Text(
          "Log In",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentLoginButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to student profile after successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // White background for button
        padding: EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      child: Center(
        child: Text(
          "Log In as Student",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "",
          style: TextStyle(color: Colors.white70, fontSize: 14),
          children: [
            TextSpan(
              text: "Forgot Password?",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Navigate to the ForgotPasswordScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1.5, color: Colors.white70)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "OR",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        Expanded(child: Divider(thickness: 1.5, color: Colors.white70)),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {
          // Handle Google login logic here
        },
        icon: Image.asset('assets/google_logo.png', width: 24),
        label: Text(
          "Continue with Google",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          backgroundColor: Colors.transparent,
          side: BorderSide(color: Colors.white, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(color: Colors.white70, fontSize: 14),
          children: [
            TextSpan(
              text: "Sign Up",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignUpScreen()), // Navigate to SignUpScreen
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
