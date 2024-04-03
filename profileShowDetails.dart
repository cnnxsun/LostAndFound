import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/CreatePost.dart';
import 'package:project1/Location.dart';
import 'package:project1/SignIn.dart';
import 'package:project1/chat.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'package:project1/homepage.dart';
import 'package:project1/profile.dart';
import 'package:project1/globalvar.dart' as globals;

enum _SelectedTab { Home, AddPost, Chat, Profile } // Nav bar

class profileShowDetails extends StatefulWidget {
  List<String>? selectedColors;
  List<PickedFile>? selectedImages;
  String? gender;
  String? breed;
  String? name;
  String? type;
  String? description;

  profileShowDetails({
    super.key,
    required this.selectedColors,
    required this.selectedImages,
    required this.gender,
    required this.breed,
    required this.name,
    required this.type,
    required this.description
  });

  @override
  _profileShowDetailsState createState() => _profileShowDetailsState();
}

class _profileShowDetailsState extends State<profileShowDetails> {
 var _selectedTab = _SelectedTab.Profile; // Nav bar
  void _handleIndexChanged(int i) {
    // Nav bar
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      if (_selectedTab == _SelectedTab.Home) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (_selectedTab == _SelectedTab.Profile) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormPage()),
        );
      } else if (_selectedTab == _SelectedTab.Chat) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Chat()),
        );
      } else if (_selectedTab == _SelectedTab.AddPost) {
        // Navigate to Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePostPage()),
        );
      }
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add any necessary logout logic here
                Navigator.pop(context); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(), // Corrected line
                  ),
                ); // Navigate back to the previous screen or login screen
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color.fromARGB(255, 34, 17, 112),
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Hi ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 17, 112),
                      fontSize: 30,
                    ),
                  ),
                  TextSpan(
                    text: globals.current_user,
                    style: TextStyle(
                      color: Color.fromARGB(255, 250, 86, 114),
                      fontSize: 30,
                    ),
                  ),
                  TextSpan(
                    text: ',',
                    style: TextStyle(
                      color: Color.fromARGB(255, 250, 86, 114),
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text(
                  "Your pet",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 34, 17, 112),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Text(
                  "Log out",
                  style: TextStyle(
                    color: Color.fromARGB(255, 250, 86, 114),
                    fontSize: 12,
                  ),
                ),
                IconButton(
                  color: const Color.fromARGB(255, 250, 86, 114),
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    _logout(); // Call the logout function when the button is pressed
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildImageDisplay(widget.selectedImages),
            _buildDisplayField("Name:  ", widget.name),
            _buildDisplayField("Type:  ", widget.type),
            _buildDisplayField("Breed:  ", widget.breed),
            _buildDisplayField("Gender:  ", widget.gender),
            _buildDisplayField("Description:  ", widget.description),
            _buildDisplayField(
              "Selected Colors:  ",
              widget.selectedColors?.join(", ") ?? "N/A",
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        // Nav bar
        height: 160,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: DotNavigationBar(
            margin: const EdgeInsets.only(left: 30, right: 30),
            currentIndex: _SelectedTab.values.indexOf(_selectedTab),
            dotIndicatorColor: const Color.fromARGB(255, 250, 86, 114),
            unselectedItemColor: Colors.grey[300],
            splashBorderRadius: 50,
            //enableFloatingNavBar: false,
            onTap: _handleIndexChanged,
            items: [
              /// Home
              DotNavigationBarItem(
                icon: const Icon(Icons.home),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),

              /// Likes
              DotNavigationBarItem(
                icon: const Icon(Icons.add_circle),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),

              /// Search
              DotNavigationBarItem(
                icon: const Icon(Icons.chat),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),

              /// Profile
              DotNavigationBarItem(
                icon: const Icon(Icons.person),
                selectedColor: const Color.fromARGB(255, 250, 86, 114),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 34, 17, 112),
              height: 1.25,
            ),
          ),
          const SizedBox(width: 8), // Add some spacing between label and value
          Text(
            value ?? "N/A",
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 250, 86, 114),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageDisplay(List<PickedFile>? images) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: images?.map((PickedFile image) {
                    return Container(
                      width: 300,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }
}
