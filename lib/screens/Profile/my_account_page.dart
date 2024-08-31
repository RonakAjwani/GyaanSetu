import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isEditing = false;
  bool showSaveChanges = false;

  // Controllers for fields
  final TextEditingController nameController = TextEditingController(text: "USER");
  final TextEditingController usernameController = TextEditingController(text: "TEST_USER");
  final TextEditingController emailController = TextEditingController(text: "abc@edu.com");
  final TextEditingController dobController = TextEditingController(text: "23/08/2004");
  final TextEditingController instituteController = TextEditingController(text: "Vidyalaya");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/user_avatar.png'), // Add your asset image here
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(Icons.edit, color: Colors.white, size: 15),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'USER',
              style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Role',
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 20),
            buildEditableField("Name", nameController, isEditing),
            buildEditableField("Username", usernameController, isEditing),
            buildEditableField("Email", emailController, isEditing),
            buildEditableField("DOB", dobController, isEditing),
            buildEditableField("Educational Institute", instituteController, isEditing),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: showSaveChanges ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: () {
                  // Save changes function
                  setState(() {
                    showSaveChanges = false;
                    isEditing = false;
                  });
                },
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), backgroundColor: Colors.deepPurple, // Adjust the color
                ),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Delete account confirmation
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Delete Account"),
                      content: Text("Are you sure you want to delete your account?"),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Delete"),
                          onPressed: () {
                            // Perform delete account
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Delete Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Adjust the color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String title, TextEditingController controller, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        showSaveChanges = true;
                      });
                    },
                  )
                : Text(
                    controller.text,
                    style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                showSaveChanges = isEditing;
              });
            },
          )
        ],
      ),
    );
  }
}
