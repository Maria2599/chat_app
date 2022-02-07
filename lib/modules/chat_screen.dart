import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static String id = "Chat_screen";

  @override
  State<StatefulWidget> createState() => _ChatScreen();
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String datetime = "";

class _ChatScreen extends State<ChatScreen> {
  late String message;
  var messageText = TextEditingController();

  //final loggedInUser=;

  // void getCurrentUser() async {
  //   //any one will login will correspond to currentUser
  //   final user = await _auth.currentUser;
  //   if (user != null) {
  //     // loggedInUser=user;
  //   }
  // }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messeges').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                // messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
        title: Center(
            child: Text(
          "Our Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                        decoration: TextFieldMessageDecoration.copyWith(
                          hintText: "New Message..."
                        ),
                    controller: messageText,
                    onChanged: (value) {
                      message = value;
                    },
                  )),
                  FlatButton(
                      onPressed: () {
                        messageText.text = "";
                        //text + sender.email
                        _firestore.collection('messeges').add({
                          "text": message,
                          "sender": _auth.currentUser!.email,
                          "datetime": datetime
                        });
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //we will listen on querySnapshot that will be in stream
      stream: _firestore.collection('messeges').orderBy("datetime").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        datetime = DateTime.now().toString();

        List<MessageBubble> messagebubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = _auth.currentUser!.email;

          final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender);

          // final messageWidget = Text('$messageText from $messageSender ');
          messagebubbles.add(messageBubble);
        }
        return Expanded(
            child: ListView(
          //makes list view at the top
          reverse: true,
          children: messagebubbles,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        ));
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(fontSize: 12.0, color: Colors.black54),
            ),
            Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0))
                  : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)),
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Text(
                  text,
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 15.0),
                ),
              ),
            )
          ]),
    );
  }
}
