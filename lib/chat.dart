import 'package:flutter/material.dart';
import 'package:project1/Location.dart';
import 'package:project1/homepage.dart';
import 'package:project1/message.dart';
import 'package:project1/noti1.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'package:project1/profile.dart';

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
            icon: Image.asset(
              'notification_icon.png',
              width: 44,
              height: 44,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage2()),
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
      body: Container(
          child: ListView.builder(
              itemCount: ChatData.dummyData.length,
              itemBuilder: (context, index) {
                ChatData _model = ChatData.dummyData[index];
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                    ),
                    GestureDetector(
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 24.0,
                            backgroundImage: AssetImage(_model.avatar)),
                        title: Row(
                          children: <Widget>[
                            Text(
                              _model.name,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              _model.datetime,
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          _model.message,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Message(chatID: _model.chatID)),
                        );
                      },
                    )
                  ],
                );
              })),
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

class ChatData {
  final int chatID;
  final String avatar;
  final String name;
  final String datetime;
  final String message;

  ChatData(
      {required this.chatID,
      required this.avatar,
      required this.name,
      required this.datetime,
      required this.message});

  static final List<ChatData> dummyData = [
    ChatData(
      chatID: 1,
      avatar: "Guwon.png",
      name: "Guwon",
      datetime: "20:22",
      message: "Thank you for helping!",
    ),
    ChatData(
      chatID: 2,
      avatar: "Adam.png",
      name: "Adam Smith",
      datetime: "19:27",
      message: "Thank you so much!",
    ),
  ];
}
