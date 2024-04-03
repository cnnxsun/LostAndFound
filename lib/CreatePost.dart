import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/Location.dart';
import 'package:project1/SignIn.dart';
import 'package:project1/chat.dart';
import 'package:project1/globalvar.dart';
import 'package:project1/homepage.dart';
import 'package:project1/noti1.dart';
import 'package:project1/profile.dart';
import 'package:project1/widgets/custom_button.dart';
import 'package:project1/custom_input.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'profileShowDetails.dart';
import 'package:project1/globalvar.dart' as globals;


import 'dart:io';

enum _SelectedTab { Home, AddPost, Chat, Profile }

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePost createState() => _CreatePost();
}

class _CreatePost extends State<CreatePostPage> with TickerProviderStateMixin {
  String? Name;
  String? Type;
  String? Breed;
  String? Gender;
  String? Description;
  String? selectedType;
  String? selectedGender;
  DateTime? MissingDate;
  String? Latitude;
  String? Longtitude;
  List<String> selectedColors = [];
  List<PickedFile> selectedImages = [];
  String current_user = globals.current_user.toString();

 var _selectedTab = _SelectedTab.AddPost; // Nav bar
  void _handleIndexChanged(int i) {
    // Nav bar
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      if (_selectedTab == _SelectedTab.Home) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (_selectedTab == _SelectedTab.Profile) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormPage()),
        );
      } else if (_selectedTab == _SelectedTab.Chat) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Chat()),
        );
      } else if (_selectedTab == _SelectedTab.AddPost) {
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

  final List<String> colorOptions = [
    "White",
    "Black",
    "Gray",
    "Orange",
    "Brown",
    "Red",
    "Gold"
  ];

  String documentId = globals.getDocumentIdByUserId('Pet', Current_userID).toString(); //Get docID for this user's pet

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          selectedImages.add(PickedFile(pickedImage.path));
          print("Selected Images: $selectedImages");
        });
      }
    } catch (e) {
      // Handle the error (show a message or log it)
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var anim = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );
    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Color.fromARGB(255, 34, 17, 112),
              fontSize: 25,
            ),
          ),
          actions: [
          IconButton(
            color: const Color.fromARGB(255, 250, 86, 114),
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage2()),
              );
            },
          ),
        ],
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
                      text: current_user,
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
              Row(
                children: [
                  const Text(
                    "Describe your pet",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 250, 86, 114),
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
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      _logout(); // Call the logout function when the button is pressed
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: selectedImages.map((PickedFile image) {
                  return Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                width: 50, // Specify the desired width
                height: 50, // Specify the desired height
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Add Image"),
                ),
              ),
              const SizedBox(height: 16),
              CustomInput(
                  hint: "Name...",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Name = value;
                    });
                  }),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: "Types",
                  border: OutlineInputBorder(),
                ),
                value: selectedType,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue.toString();
                    Type = selectedType;
                  });
                },
                items: ["Dog", "Cat", "Others"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              CustomInput(
                  hint: "Breed",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Breed = value;
                    });
                  }),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: "Gender",
                  border: OutlineInputBorder(),
                ),
                value: selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue.toString();
                    Gender = selectedGender;
                  });
                },
                items: ["Male", "Female"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: const InputDecoration(
                  hintText: "Selected Colors",
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(selectedColors.isEmpty
                          ? "Select Colors"
                          : selectedColors.join(", ")),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: colorOptions.map((String color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedColors.contains(color)) {
                          selectedColors.remove(color);
                        } else {
                          selectedColors.add(color);
                        }
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: selectedColors.contains(color)
                              ? const Color.fromARGB(255, 250, 86, 114)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color.fromARGB(
                                255, 34, 17, 112), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Text(
                          color,
                          style: TextStyle(
                            color: selectedColors.contains(color)
                                ? Colors.white
                                : const Color.fromARGB(255, 34, 17, 112),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              CustomInput(
                  hint: "Description...",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Description = value;
                    });
                  }),
              CustomInput(
                  hint: "Latitude",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Latitude = value;
                    });
                  }),
              CustomInput(
                  hint: "Longitude",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Longtitude = value;
                    });
                  }),
              const SizedBox(height: 32),
              CustomBtn(
                title: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                callback: () async {
                  // Handle the save action, e.g., print the selected colors and images
                  print("Selected colors: $selectedColors");
                  print("Selected images: $selectedImages");
                  print("Gender: $Gender");
                  print("Breed: $Breed");
                  print("Name: $Name");
                  print("Type: $Type");
                  print("Description: $Description");
                  print("Latitude: $Latitude");
                  print("Longtitude: $Longtitude");

                  int count = await globals.getTotalDocumentCount('Post');
                   Map<String, String> dataToSave={
                      'User_ID': globals.Current_userID.toString(),
                      'Name': Name.toString(),
                      'Types': Type.toString(),
                      'Breed': Breed.toString(),
                      'Sex': Gender.toString(),
                      'Colors': selectedColors.toString(),
                      'Description': Description.toString(),
                      'Latitude': Latitude.toString(),
                      'Longtitude': Longtitude.toString(),
                      'Post_ID': (count+1).toString(),
                      'CreatedOn': DateTime.now().toString()
                    };
                    FirebaseFirestore.instance.collection('Post').add(dataToSave);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox( 
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
      ),
    );
  }
}
