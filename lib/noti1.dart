import 'package:flutter/material.dart';
import 'package:project1/Location.dart';
import 'package:project1/chat.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'package:project1/homepage.dart';
import 'package:project1/profile.dart';

enum _SelectedTab { Home, AddPost, Chat, Profile } // Nav bar


class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({Key? key}) : super(key: key);

  @override
  State<SettingsPage2> createState() => _SettingsPage2State();
}

class _SettingsPage2State extends State<SettingsPage2> {
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
          MaterialPageRoute(builder: (context) => const GoogleMapPage()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Block
        backgroundColor: Colors.white,
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
          'Notification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0xFF26117A),
          ),
        ),
        centerTitle: true,
      ),
        body: Center(
          child: Container(
            child: ListView(
              children: [
                _SingleSection(
                  title: "New",
                  children: [
                    const _CustomListTile(
                        title: "Guwon posted a new Found!!! post    8m",
                        imagePath: "Guwon.png",
                      ),
                      SizedBox(height: 10.0),
                    const _CustomListTile(
                        title: "Adam Smith sent a message to you    9 m ",
                        imagePath: "Adam.png",
                      ),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Yesterday",
                  children: [
                    _CustomListTile(
                        title: "Adam Smith matched with Pepper    8 h ",
                        imagePath: "Adam.png",
                      ),
                  ],
                ),
                const Divider(),
                const _SingleSection(
                  title: "Last 30 days",
                  children: [
                    _CustomListTile(
                        title: "Guwon posted a new Missing!!! post  1 w ",
                        imagePath: "Guwon.png",
                        ),
                  ],
                ),
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


class _CustomListTile extends StatelessWidget {
  final String title;
  final String imagePath;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the next page here
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Chat(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 250, 86, 114),
                width: 2.0,
              ),
            ),
            child:  CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 20, color: Color(0xFF26117A), fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}