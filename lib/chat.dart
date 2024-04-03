import 'package:flutter/material.dart';
import 'package:project1/Location.dart';
import 'package:project1/homepage.dart';
import 'package:project1/message.dart';
import 'package:project1/noti1.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'package:project1/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum _SelectedTab { Home, AddPost, Chat, Profile } // Nav bar

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  var _selectedTab = _SelectedTab.Chat; // Nav bar
  void _handleIndexChanged(int i) {
    // Nav bar
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      if (_selectedTab == _SelectedTab.Home) {
        // Navigate to Homepage
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
        // Navigate to Chat
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Chat()),
        );
      } else if (_selectedTab == _SelectedTab.AddPost) {
        // Navigate to CreatePost
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoogleMapPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        // Block
        backgroundColor: Colors.white,
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
        // Line
        //elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12), //space between text and line
          child: Container(
            height: 2.0, //Line Size
            color: const Color.fromARGB(255, 250, 86, 114),
          ),
        ),
        // Text of Appbar
        title: Text(
          'Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0xFF26117A),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('datetime', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final chatData = snapshot.data!;
            return ListView.builder(
              itemCount: chatData.length,
              itemBuilder: (context, index) {
                final _message = chatData[index];
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                    ),
                    GestureDetector(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24.0,
                          backgroundImage: AssetImage(
                              _message['avatar']), // assuming avatar is a path
                        ),
                        title: Row(
                          children: <Widget>[
                            Text(
                              _message['name'],
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              _formatTimestamp(
                                _message['datetime'],
                              ),
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          _message['message'],
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Message(chatID: _message['chatID']),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
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

String _formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat.jm().format(dateTime);
}
