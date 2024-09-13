import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:gyaan_setu/screens/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? _selectedRole = 'Teacher';
  String password = '';
  double passwordStrength = 0.0;
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Updated color scheme with shades of purple
  final Color primaryColor = Color(0xFF8E44AD); // Deep purple
  final Color secondaryColor = Color(0xFF9B59B6); // Medium purple
  final Color accentColor = Color(0xFFAF7AC5); // Light purple
  final Color backgroundColor = Color(0xFFF4ECF7); // Very light purple
  final Color textColor = Color(0xFF4A235A); // Dark purple
  final Color errorColor = Color(0xFFE74C3C); // Keep red for errors

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _fullNameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'role': _selectedRole,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoAndAppName(),
              SizedBox(height: 30),
              _buildTextField("Email", Icons.email, _emailController),
              SizedBox(height: 16),
              _buildTextField("Full Name", Icons.person, _fullNameController),
              SizedBox(height: 16),
              _buildTextField(
                  "Username", Icons.account_circle, _usernameController),
              SizedBox(height: 16),
              _buildPasswordTextField(
                  "Password", Icons.lock, _passwordController,
                  isConfirmPassword: false),
              SizedBox(height: 8),
              _buildPasswordStrengthIndicator(),
              SizedBox(height: 16),
              _buildPasswordTextField(
                  "Confirm Password", Icons.lock, _confirmPasswordController,
                  isConfirmPassword: true),
              SizedBox(height: 24),
              _buildRoleSelection(),
              SizedBox(height: 32),
              _buildSignUpButton(),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: errorColor),
                  ),
                ),
              SizedBox(height: 24),
              _buildLoginText(context),
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
      String hintText, IconData icon, TextEditingController controller,
      {bool isConfirmPassword = false}) {
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
        obscureText:
            isConfirmPassword ? _obscureConfirmPassword : _obscurePassword,
        onChanged: (value) {
          if (!isConfirmPassword) {
            setState(() {
              password = value;
              passwordStrength = _calculatePasswordStrength(value);
            });
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(color: textColor.withOpacity(0.6)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: secondaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirmPassword
                  ? (_obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility)
                  : (_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
              color: textColor.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                if (isConfirmPassword) {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                } else {
                  _obscurePassword = !_obscurePassword;
                }
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

  double _calculatePasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.10;
    return strength > 1 ? 1 : strength;
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _getStrengthColor(index),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8),
        Text(
          _getPasswordStrengthText(),
          style: GoogleFonts.nunito(
            color: _getStrengthColor(3),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getStrengthColor(int index) {
    if (passwordStrength == 0) return Colors.grey.withOpacity(0.3);
    if (passwordStrength <= 0.25 && index == 0) return errorColor;
    if (passwordStrength <= 0.5 && index <= 1) return Colors.orange;
    if (passwordStrength <= 0.75 && index <= 2) return Colors.yellow;
    if (passwordStrength <= 1 && index <= 3) return primaryColor;
    return Colors.grey.withOpacity(0.3);
  }

  String _getPasswordStrengthText() {
    if (passwordStrength == 0) return "Enter a password";
    if (passwordStrength <= 0.25) return "Weak";
    if (passwordStrength <= 0.5) return "Fair";
    if (passwordStrength <= 0.75) return "Good";
    return "Strong";
  }

  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleButton('Teacher'),
        SizedBox(width: 16),
        _buildRoleButton('Student'),
      ],
    );
  }

  Widget _buildRoleButton(String role) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: isSelected ? primaryColor : textColor.withOpacity(0.2),
              width: 2),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          role,
          style: GoogleFonts.nunito(
            color: isSelected ? Colors.white : textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
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
        onPressed: _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          "Create account",
          style: GoogleFonts.nunito(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: GoogleFonts.nunito(color: textColor, fontSize: 16),
          children: [
            TextSpan(
              text: "Log in",
              style: GoogleFonts.nunito(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
