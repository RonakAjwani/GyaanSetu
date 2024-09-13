import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import '../SignUp/signup_screen.dart';
import 'forgot_password_screen.dart';
import '../Home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? _errorMessage;
  bool _obscurePassword = true;

  // Updated color scheme
  final Color primaryColor = Color(0xFF8E44AD); // Deep purple
  final Color secondaryColor = Color(0xFF9B59B6); // Medium purple
  final Color accentColor = Color(0xFFAF7AC5); // Light purple
  final Color backgroundColor = Color(0xFFF4ECF7); // Very light purple
  final Color textColor = Color(0xFF4A235A); // Dark purple
  final Color errorColor = Color(0xFFE74C3C); // Keep red for errors

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoAndAppName(),
              SizedBox(height: 40),
              Text(
                "Welcome back!",
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Log in to continue your learning journey",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField("Email", Icons.email, _emailController),
              SizedBox(height: 16),
              _buildPasswordTextField(
                  "Password", Icons.lock, _passwordController),
              SizedBox(height: 24),
              _buildForgotPasswordText(context),
              SizedBox(height: 32),
              _buildLoginButton(),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: errorColor),
                  ),
                ),
              SizedBox(height: 24),
              _buildSignUpText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(color: textColor.withOpacity(0.6)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: secondaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
        style: GoogleFonts.nunito(color: textColor),
      ),
    );
  }

  Widget _buildPasswordTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(color: textColor.withOpacity(0.6)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: secondaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: textColor.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
        style: GoogleFonts.nunito(color: textColor),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          "Log In",
          style: GoogleFonts.nunito(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordText(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        child: Text(
          "Forgot Password?",
          style: GoogleFonts.nunito(
            color: secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: GoogleFonts.nunito(color: textColor, fontSize: 16),
          children: [
            TextSpan(
              text: "Sign Up",
              style: GoogleFonts.nunito(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoAndAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/gyaansetu.logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 16),
        Text(
          "GyaanSetu",
          style: GoogleFonts.nunito(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
