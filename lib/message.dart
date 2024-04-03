import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Message extends StatefulWidget {
  final int chatID;

  const Message({Key? key, required this.chatID}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.chatID.toString())
              .collection('messages')
              .orderBy('datetime', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Loading...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xFF26117A),
                ),
              );
            }

            final messages = snapshot.data!.docs;
            final firstMessage = messages.first.data() as Map<String, dynamic>;
            final receiverName =
                firstMessage['receipt'] ? 'Chat' : firstMessage['name'];

            return Text(
              receiverName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF26117A),
              ),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12),
          child: Container(
            height: 2.0,
            color: const Color.fromARGB(255, 250, 86, 114),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(widget.chatID.toString())
                    .collection('messages')
                    .orderBy('datetime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData =
                          messages[index].data() as Map<String, dynamic>;

                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        child: Row(
                          children: [
                            if (!messageData['receipt']) ...[
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(messageData['avatar']),
                              ),
                              SizedBox(width: 10.0),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: messageData['receipt']
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(_formatTimestamp(
                                      messageData['datetime'])),
                                  SizedBox(height: 5.0),
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: messageData['receipt']
                                          ? Color.fromARGB(255, 250, 86, 114)
                                          : Color(0xFF26117A),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Text(
                                      messageData['message'],
                                      style: TextStyle(
                                        color: Color.fromARGB(
                                          255,
                                          219,
                                          219,
                                          219,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (messageData['receipt']) ...[
                              SizedBox(width: 10.0),
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(messageData['avatar']),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: 60.0,
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type your message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final message = _messageController.text;
                      if (message.isNotEmpty) {
                        // Send message to Firebase
                        _sendMessage(message);
                        _messageController.clear();
                      }
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

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime);
  }

  void _sendMessage(String message) async {
    final firestore = FirebaseFirestore.instance;

    final messageData = {
      'message': message,
      'datetime': Timestamp.now(),
      'receipt': true,
      'name': 'Sarah',
      'avatar': 'Sarah.png',
    };

    await firestore
        .collection('chat')
        .doc(widget.chatID.toString())
        .collection('messages')
        .add(messageData);
  }
}
