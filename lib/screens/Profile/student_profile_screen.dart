import 'package:flutter/material.dart';
import 'my_account_page.dart'; // Import your MyAccountPage
import '../Courses/courses_page.dart'; // Ensure this points to the correct location
import '../Whiteboard/whiteboard_page.dart'; // Ensure this points to the correct location
import '../Home/home_page.dart'; // Import your HomePage
import '../Gamification/word_guess.dart'; // Import your WordGuessingGame

class StudentProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Match the HomePage background color
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture and Info
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                    'assets/default_avatar.png'), // Ensure this asset exists
              ),
              SizedBox(height: 15),
              Text(
                "User_name",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(height: 5),
              Text(
                "+91 98765 43210",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              Text(
                "abc@edu.com",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 30),

              // My Account, Privacy, Settings Options
              _buildProfileOption(
                icon: Icons.person,
                title: "My Account",
                onTap: () {
                  // Navigate to My Account Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyAccountPage()), // Link to MyAccountPage
                  );
                },
              ),
              _buildProfileOption(
                icon: Icons.privacy_tip,
                title: "Privacy",
                onTap: () {
                  // Handle Privacy tap
                },
              ),
              _buildProfileOption(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  // Handle Settings tap
                },
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: "Help & Support",
                onTap: () {
                  // Handle Help & Support tap
                },
              ),
              SizedBox(height: 40),

              // Sign Out Button
              ElevatedButton(
                onPressed: () {
                  // Handle Sign Out
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // About App Information
              Text(
                "About App\nVersion 1.0.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey[700]),
        title:
            Text(title, style: TextStyle(fontSize: 18, color: Colors.black87)),
        trailing:
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 4, // Assuming Profile is the 5th item
      selectedItemColor: Colors.blue, // Highlighted color for the selected item
      unselectedItemColor: Colors.grey[600], // Color for unselected items
      backgroundColor: Colors.white, // Match with the app's primary background
      showUnselectedLabels: true,
      onTap: (index) {
        switch (index) {
          case 0:
            // Navigate to Courses page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Courses()),
            );
            break;
          case 1:
            // Navigate to Whiteboard page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WhiteboardPage()),
            );
            break;
          case 2:
            // Navigate to Home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 3:
            // Navigate to Game1 page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WordGuessingGame()),
            );
            break;
          case 4:
            // Stay on Profile page (no navigation needed)
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Courses",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Whiteboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset),
          label: "Game",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
