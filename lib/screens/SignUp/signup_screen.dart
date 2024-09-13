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
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 232, 207, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
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
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          "Let's create an account",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: const Color.fromARGB(179, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.person_add_alt_1,
                        color: const Color.fromARGB(255, 0, 0, 0), size: 30),
                  ],
                ),
                SizedBox(height: 40),
                _buildTextField(
                    "Email or Phone Number", Icons.email, _emailController),
                SizedBox(height: 20),
                _buildTextField("Full Name", Icons.person, _fullNameController),
                SizedBox(height: 20),
                _buildTextField(
                    "Username", Icons.account_circle, _usernameController),
                SizedBox(height: 20),
                _buildPasswordTextField(
                    "Password", Icons.lock, _passwordController),
                SizedBox(height: 5),
                _buildPasswordStrengthIndicator(),
                SizedBox(height: 20),
                _buildPasswordTextField(
                    "Confirm Password", Icons.lock, _confirmPasswordController),
                SizedBox(height: 30),
                _buildRoleSelection(),
                SizedBox(height: 30),
                _buildSignUpButton(),
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 30),
                _buildOrDivider(),
                SizedBox(height: 20),
                _buildGoogleSignUpButton(),
                SizedBox(height: 30),
                _buildLoginText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 91, 91, 91)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
    );
  }

  Widget _buildPasswordTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      onChanged: (value) {
        setState(() {
          password = value;
          passwordStrength = _calculatePasswordStrength(value);
        });
      },
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 91, 91, 91)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        suffixIcon: Icon(Icons.visibility_off,
            color: const Color.fromARGB(179, 22, 22, 22)),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  double _calculatePasswordStrength(String password) {
    double strength = 0.0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    return strength;
  }

  Widget _buildPasswordStrengthIndicator() {
    return LinearProgressIndicator(
      value: passwordStrength,
      backgroundColor: Colors.white.withOpacity(0.3),
      valueColor: AlwaysStoppedAnimation<Color>(
          passwordStrength < 0.5 ? Colors.red : Colors.green),
    );
  }

  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleButton('Teacher'),
        SizedBox(width: 15),
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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 159, 140, 159)
              : const Color.fromARGB(0, 99, 94, 94),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color:
                          const Color.fromARGB(255, 3, 3, 3).withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]
              : [],
        ),
        child: Text(
          role,
          style: TextStyle(
            color:
                isSelected ? Color.fromARGB(255, 255, 255, 255) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      child: Center(
        child: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
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

  Widget _buildGoogleSignUpButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {
          // Handle Google sign-up logic here
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

  Widget _buildLoginText(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(color: Colors.white70, fontSize: 14),
          children: [
            TextSpan(
              text: "Log in",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
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
}
