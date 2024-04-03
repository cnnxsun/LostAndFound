import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/Location.dart';
import 'package:project1/cat_lost_found.dart';
import 'package:project1/chat.dart';
import 'package:project1/profile.dart';
import 'package:project1/noti1.dart';
import 'package:project1/others.dart';
import 'package:project1/dog_lost_found.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'package:project1/globalvar.dart' as globals;
import 'package:project1/CreatePost.dart';
import 'dart:convert';



enum _SelectedTab { Home, AddPost, Chat, Profile } // Nav bar

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedTab = _SelectedTab.Home; // Nav bar
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Homepage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF26117A),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              PageHeader(),
              const SizedBox(height: 20),
              Hellopage(),
              const SizedBox(height: 20),
              OvalSearchBar(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OptionCircle(
                    text: 'Dog',
                    circleColor: const Color(0xFFD5EEF6),
                    imagePath: 'assets/DogSelect.png',
                    onTap: () {
                      // Navigate to CatLostFound screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DogLostFound()),
                      );
                    },
                  ),
                  const SizedBox(width: 10), // Add spacing between circles
                  OptionCircle(
                    text: 'Cat',
                    circleColor: const Color(0xFFF9EFCB),
                    imagePath: 'assets/Cat2.png',
                    onTap: () {
                      // Navigate to CatLostFound screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CatLostFound()),
                      );
                    },
                  ),
                  const SizedBox(width: 10), // Add spacing between circles
                  OptionCircle(
                    text: 'Others',
                    circleColor: const Color(0xFFFBE3E3),
                    imagePath: 'assets/BlueBird.png',
                    onTap: () {
                      // Navigate to CatLostFound screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => othersLostFound()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              UserInfoList(),
            ],
          ),
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
}

class OptionCircle extends StatelessWidget {
  final String text;
  final String imagePath; // Changed from IconData to String for the image path
  final Color circleColor;
  final VoidCallback onTap;

  const OptionCircle({
    required this.text,
    required this.imagePath, // Updated the constructor
    required this.circleColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60, // Adjust the width of the circle
            height: 60, // Adjust the height of the circle
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 40, // Adjust the width of the image
                height: 40, // Adjust the height of the image
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/Cloud.png',
          fit: BoxFit.cover, // Ensure the image covers the entire area
          width: MediaQuery.of(context)
              .size
              .width, // Set the width to match the screen width
          height: 200, // Adjust the height as needed
        ),
        Column(
          children: [
            const SizedBox(height: 20), // Add some spacing from the top
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Hi ',
                    style: TextStyle(
                      color: Color(0xFF26117A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: globals.current_user,
                    style: TextStyle(
                      color: Color.fromARGB(255, 253, 88, 115),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ', \n\n',
                    style: TextStyle(
                      color: Color(0xFF26117A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: 'Where is my pet?!',
                    style: TextStyle(
                      color: Color(0xFF26117A),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Hellopage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/pink.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 210,
            ),
            Image.asset(
              'assets/Homepic.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 300,
            ),
            Image.asset(
              'assets/Paw.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 210,
            ),
          ],
        ),
      ],
    );
  }
}

class OvalSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.search),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//================================================================================================================================================================================

class UserInfoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Post').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final documents = snapshot.data!.docs;
final userInfoWidgets = documents.map((doc) {
  final data = doc.data() as Map<String, dynamic>;
  final colorsString = data['Colors'] ?? '';
  List<String> colorsList = [];

  if (colorsString.isNotEmpty) {
    // Remove brackets and split the string by comma
    colorsList = colorsString.substring(1, colorsString.length - 1).split(',');
    // Trim whitespace from each color and add to the list
    colorsList = colorsList.map((color) => color.trim()).toList();
  }
            return UserInfo(
              Name: data['Name'] ?? '',
              type: data['Types'] ?? '',
              breed: data['Breed'] ?? '',
              gender: data['Sex'] ?? '',
              colors: colorsList,
              description: data['Description'] ?? '',
              createdOn: data['CreatedOn'] ?? '',
              latitude: data['Latitude'] ?? '',
              longitude: data['Longtitude'] ?? '',
              postId: data['Post_ID'] ?? '',
              UserID: data['User_ID'] ?? '',

            );
            
          }).toList();
          
          final userInfoFetcher = documents.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final colorsString = data['Colors'] ?? '';
            List<String> colorsList = [];
            try {
              colorsList = List<String>.from(json.decode(colorsString));
            } catch (e) {
              print('Error parsing colors: $e');
            }
            return FetchUser(
              UserID: data['User_ID'] ?? '',

            );
            
          });
          
          return ListView(
            children: userInfoWidgets,
            
          );
        },
      ),
    );
  }
}



class UserInfo extends StatelessWidget {
  final String Name;
  final String type;
  final String breed;
  final String gender;
  final List<String> colors;
  final String description;
  final String createdOn;
  final String latitude;
  final String longitude;
  final String postId;
  final String UserID;

  UserInfo({
    required this.Name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.colors,
    required this.description,
    required this.createdOn,
    required this.latitude,
    required this.longitude,
    required this.postId,
    required this.UserID,
  });

  @override
  Widget build(BuildContext context) {
    // Define the default asset path
    String assetPath;

    // Conditionally set the asset path based on the type variable
    if (type == 'Dog') {
      assetPath = 'assets/Dog3.png';
    } else if (type == 'Cat') {
      assetPath = 'assets/cat.png';
    }
    else{
      assetPath = 'assets/BlueBird.png';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FetchUser(UserID: UserID),
          SizedBox(height: 10), // Add some vertical spacing
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 210,
              width: double.infinity,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'Name: $Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          Text(
            'Type: $type',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          Text(
            'Breed: $breed',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          Text(
            'Gender: $gender',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          Text(
            'Colors: ${colors.join(', ')}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          Text(
            'Description: $description',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          Text(
            'Created On: $createdOn',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          ),
          // Text(
          //   'Latitude: $latitude',
          //   style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          // ),
          // Text(
          //   'Longitude: $longitude',
          //   style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          // ),
          // Text(
          //   'Post ID: $postId',
          //   style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF26117A)),
          // ),
          SizedBox(height: 20),
          ContactButton(),
          SizedBox(height: 10), // Add some vertical spacing
          
          FutureBuilder<List<double?>>(
            future: Future.wait([
              globals.getLatitudeByPostID(postId),
              globals.getLongitudeByPostID(postId),
            ]),
            builder: (context, AsyncSnapshot<List<double?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator while waiting for data
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  // Return an error message if an error occurs
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Extract latitude and longitude from the snapshot data
                  double? latitude = snapshot.data?[0] ?? 0.0;
                  double? longitude = snapshot.data?[1] ?? 0.0;

                  // Return the LocationButton widget with the retrieved latitude and longitude
                  return LocationButton(
                      latitude: latitude, longitude: longitude);
                }
              }
            },
          ),
          SizedBox(height: 50), // Add some vertical spacing
        ],
      ),
    );
  }
}


class ContactButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFFA5672), // Oval pink contact button color
      ),
      child: TextButton(
        onPressed: () {
          // Add functionality for contact button
        },
        child: const Text(
          'Contact',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  final double latitude;
  final double longitude;

  LocationButton({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(255, 91, 177, 57), // Oval pink contact button color
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoogleMapPage(latitude: latitude, longitude: longitude)), // Pass latitude and longitude as doubles
          );
        },
        child: const Text(
          'Location',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


class FetchUser extends StatelessWidget {
  final String UserID;

  FetchUser({
    required this.UserID,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox( // Wrapping with SizedBox to provide constraints
        width: double.infinity, // Use full width available
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('UserStockImg.png'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: globals.getUsernameByID(UserID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26117A),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26117A),
                              ),
                            );
                          } else {
                            String? userFullName = snapshot.data;
                            return Text(
                              userFullName ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26117A),
                              ),
                            );
                          }
                        },
                      ),
                      FutureBuilder<String?>(
                        future: globals.getLocationByID(UserID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26117A),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26117A),
                              ),
                            );
                          } else {
                            String? location = snapshot.data;
                            return Text(
                              location ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF26117A),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




// class UserInfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: CircleAvatar(
//                   backgroundImage: AssetImage('assets/qndska.png'),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Text(
//                           'Qndska',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF26117A)),
//                         ),
//                         Spacer(),
//                         Text(
//                           '...',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Salaya, Phutthamonthon District, Nakhon Pathom',
//                       style: TextStyle(color: Colors.grey[400]!, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: SizedBox(
//               height: 210,
//               width: double.infinity,
//               child: Image.asset(
//                 'assets/cat.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text('Name: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))), // Added 3 tabs
//                   SizedBox(width: 62),
//                   Text('Percy', style: TextStyle(color: Colors.black)),
//                   Spacer(),
//                   Text('Missing!!!',
//                       style: TextStyle(color: Color(0xFFFF0E0E))),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Type: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 69),
//                   Text('Cat', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Breed: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 64),
//                   Text('Domestic Shorthair',
//                       style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Gender: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))), // Added 3 tabs
//                   SizedBox(width: 54),
//                   Text('Male', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Color: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 65),
//                   Text('White/Orange', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Description: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 30),
//                   Text('...', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Text('8 m ago',
//                   style: TextStyle(color: Color(0xFF979797), fontSize: 12)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ContactButton(),
//           const SizedBox(height: 10),
//           LocationButton(),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }

// class ContactButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: const Color(0xFFFA5672), // Oval pink contact button color
//       ),
//       child: TextButton(
//         onPressed: () {
//           // Add functionality for contact button
//         },
//         child: const Text(
//           'Contact',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

// class LocationButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Color.fromARGB(255, 91, 177, 57), // Oval pink contact button color
//       ),
//       child: TextButton(
//         onPressed: () {
//           Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => GoogleMapPage()),
//           );
//         },
//         child: const Text(
//           'Location',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
      
//     );
//   }
// }

// class UserInfofound extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: CircleAvatar(
//                   backgroundImage: AssetImage('assets/guwon.png'),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Text(
//                           'Guwon',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF26117A)),
//                         ),
//                         Spacer(),
//                         Text(
//                           '...',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Salaya, Phutthamonthon District, Nakhon Pathom',
//                       style: TextStyle(color: Colors.grey[400]!, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: SizedBox(
//               height: 210,
//               width: double.infinity,
//               child: Image.asset(
//                 'assets/ragdoll.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text('Name: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))), // Added 3 tabs
//                   SizedBox(width: 62),
//                   Text('Lauren', style: TextStyle(color: Colors.black)),
//                   Spacer(),
//                   Text('found!!!', style: TextStyle(color: Color(0xFF5DB075))),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Type: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 69),
//                   Text('Cat', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Breed: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 64),
//                   Text('Ragdoll', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Gender: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))), // Added 3 tabs
//                   SizedBox(width: 54),
//                   Text('Female', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Color: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 65),
//                   Text('White/Brown', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   SizedBox(height: 10),
//                   Text('Description: ',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF26117A))),
//                   SizedBox(width: 30),
//                   Text('...', style: TextStyle(color: Colors.black)),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Text('8 m ago',
//                   style: TextStyle(color: Color(0xFF979797), fontSize: 12)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ContactButton(),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
