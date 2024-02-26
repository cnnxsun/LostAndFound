import 'package:flutter/material.dart';


class Message extends StatelessWidget {
  
  final int chatID;

  const Message({Key? key, required this.chatID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatData conversation = ChatData.dummyData
        .firstWhere((chat) => chat.chatID == chatID); // Find by chatID

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          conversation.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0xFF26117A),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12), // Space between text and line
          child: Container(
            height: 2.0, // Line size
            color: const Color.fromARGB(255, 250, 86, 114),
          ),
        ),
      ),
      // Add padding to the body
      body: Padding(
        padding: EdgeInsets.only(top: 20.0), // Adjust the top padding as needed
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ChatData.dummyData
                    .where((chat) => chat.chatID == chatID)
                    .length,
                itemBuilder: (context, index) {
                  ChatData message = ChatData.dummyData
                      .where((chat) => chat.chatID == chatID)
                      .toList()[index];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Row(
                      children: [
                        if (!message.receipt) ...[
                          // Display avatar for sender on left
                          CircleAvatar(
                            backgroundImage: AssetImage(message.avatar),
                          ),
                          SizedBox(width: 10.0),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: message.receipt
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // Timestamp alignment based on receipt
                              Text(message.datetime),
                              SizedBox(height: 5.0), // Spacing between timestamp and message
                              Container(
                                // Bubble box for text
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: message.receipt
                                      ? Color.fromARGB(255, 250, 86, 114)
                                      : Color(0xFF26117A),
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Text(
                                  message.message,
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 219, 219, 219),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (message.receipt) ...[
                          // Display avatar for receiver on right
                          SizedBox(width: 10.0),
                          CircleAvatar(
                            backgroundImage: AssetImage(message.avatar),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            // New navbar for texting
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: 60.0,
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type your message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Message sent!"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
  final bool receipt;

  const ChatData({
    required this.chatID,
    required this.avatar,
    required this.name,
    required this.datetime,
    required this.message,
    required this.receipt,
  });

  static final List<ChatData> dummyData = [
    // Chat 1 (Sarah and Guwon)
    ChatData(
      chatID: 1,
      avatar: "Guwon.png",
      name: "Guwon",
      datetime: "20:18 AM",
      message: "How can I return the favor?",
      receipt: false,
    ),
    ChatData(
      chatID: 1,
      avatar: "Sarah.png",
      name: "Sarah",
      datetime: "20:20 AM",
      message: "No problem, happy to help!",
      receipt: true,
    ),
    ChatData(
      chatID: 1,
      avatar: "Guwon.png",
      name: "Guwon",
      datetime: "20:22 AM",
      message: "Thank you for helping",
      receipt: false,
    ),
    // Chat 2 (Sarah and Adam)
    ChatData(
      chatID: 2,
      avatar: "Adam.png",
      name: "Adam Smith",
      datetime: "19:22 AM",
      message: "May you help me in this weekend?",
      receipt: false,
    ),
    ChatData(
      chatID: 2,
      avatar: "Sarah.png",
      name: "Sarah",
      datetime: "19:25 AM",
      message: "You're welcome, Adam!",
      receipt: true,
    ),
    ChatData(
      chatID: 2,
      avatar: "Adam.png",
      name: "Adam Smith",
      datetime: "19:27 AM",
      message: "Thank you so much!",
      receipt: false,
    ),
  ];
}