import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/constant_app_bar.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final Color primaryColor = const Color(0xFF1A5F7A);
  final Color secondaryColor = const Color(0xFF2E8BC0);
  final Color accentColor = const Color(0xFFFFB703);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color textColor = const Color(0xFF333333);

  bool isEditing = false;

  // Controllers for fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        nameController.text = userData.get('name') ?? '';
        usernameController.text = userData.get('username') ?? '';
        emailController.text = user.email ?? '';
        dobController.text = userData.get('dob') ?? '';
        instituteController.text = userData.get('institute') ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': nameController.text,
        'username': usernameController.text,
        'dob': dobController.text,
        'institute': instituteController.text,
      });
      setState(() {
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConstantAppBar(title: 'My Account'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/default_avatar.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryColor,
                    child: IconButton(
                      icon:
                          const Icon(Icons.edit, color: Colors.white, size: 20),
                      onPressed: () {
                        // TODO: Implement image change functionality
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              nameController.text,
              style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            Text(
              'Student',
              style: GoogleFonts.nunito(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 30),
            buildEditableField("Name", nameController, Icons.person),
            buildEditableField(
                "Username", usernameController, Icons.alternate_email),
            buildEditableField("Email", emailController, Icons.email,
                enabled: false),
            buildEditableField("Date of Birth", dobController, Icons.cake),
            buildEditableField(
                "Educational Institute", instituteController, Icons.school),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: isEditing
                  ? _saveChanges
                  : () {
                      setState(() {
                        isEditing = true;
                      });
                    },
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              label: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                // Delete account confirmation
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Account"),
                      content: const Text(
                          "Are you sure you want to delete your account? This action cannot be undone."),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text("Delete",
                              style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            // TODO: Implement account deletion
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text('Delete Account',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(
      String title, TextEditingController controller, IconData icon,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        enabled: isEditing && enabled,
        style: GoogleFonts.nunito(fontSize: 16, color: textColor),
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: secondaryColor, width: 2),
          ),
        ),
      ),
    );
  }
}
