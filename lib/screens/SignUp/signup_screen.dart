import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:gyaan_setu/screens/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // Color scheme
  final Color primaryColor = Color(0xFF1A5F7A);
  final Color secondaryColor = Color(0xFF2E8BC0);
  final Color accentColor = Color(0xFFFFB703);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color textColor = Color(0xFF333333);
  final Color lightTextColor = Color(0xFF757575);
  final Color errorColor = Color(0xFFD62828);

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

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Delay for a moment to show the success message
      await Future.delayed(Duration(seconds: 2));

      // Navigate to login screen with a fade transition
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogoAndAppName(),
              SizedBox(height: 40),
              Text(
                "Create your account",
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
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
                    textAlign: TextAlign.center,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          hintStyle: GoogleFonts.roboto(color: lightTextColor),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: primaryColor, size: 24),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: GoogleFonts.roboto(color: textColor, fontSize: 16),
      ),
    );
  }

  Widget _buildPasswordTextField(
      String hintText, IconData icon, TextEditingController controller,
      {bool isConfirmPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          hintStyle: GoogleFonts.roboto(color: lightTextColor),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: primaryColor, size: 24),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirmPassword
                  ? (_obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility)
                  : (_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
              color: lightTextColor,
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: GoogleFonts.roboto(color: textColor, fontSize: 16),
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
        SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: FractionallySizedBox(
            widthFactor: passwordStrength,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _getStrengthColor(3),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getPasswordStrengthText(),
              style: GoogleFonts.roboto(
                color: _getStrengthColor(3),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              'Password strength',
              style: GoogleFonts.roboto(
                color: lightTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStrengthColor(int index) {
    if (passwordStrength == 0) return Colors.grey.withOpacity(0.3);
    if (passwordStrength <= 0.25) return errorColor;
    if (passwordStrength <= 0.5) return Colors.orange;
    if (passwordStrength <= 0.75) return Colors.yellow;
    return primaryColor;
  }

  String _getPasswordStrengthText() {
    if (passwordStrength == 0) return "No password";
    if (passwordStrength <= 0.25) return "Weak";
    if (passwordStrength <= 0.5) return "Fair";
    if (passwordStrength <= 0.75) return "Good";
    return "Strong";
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I am a:",
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleButton('Teacher'),
            SizedBox(width: 16),
            _buildRoleButton('Student'),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleButton(String role) {
    bool isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : textColor.withOpacity(0.2),
              width: 2,
            ),
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
            style: GoogleFonts.roboto(
              color: isSelected ? Colors.white : textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          "Create account",
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: textColor,
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
          style: GoogleFonts.roboto(color: textColor, fontSize: 16),
          children: [
            TextSpan(
              text: "Log in",
              style: GoogleFonts.roboto(
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
    return Column(
      children: [
        SvgPicture.asset(
          'assets/app_logo.svg',
          width: 120,
          height: 120,
        ),
        SizedBox(height: 16),
        Text(
          "GyaanSetu",
          style: GoogleFonts.roboto(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}
