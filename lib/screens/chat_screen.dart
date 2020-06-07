import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseUser loginUser;

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final textController = TextEditingController();
  List<Widget> messagesList = [];
  String message;
  @override
  void initState() {
    super.initState();
    getAuth();
//    controller = AnimationController(
//      vsync: this,
//      duration: Duration(seconds: 10),
//    );
//    animation =
//        ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);
//    controller.forward();
//    controller.addListener(() {
//      setState(() {});
//    });
//    controller.addStatusListener((status) {
//      print(animation.value);
//    });
  }

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  void getAuth() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loginUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

//  void getData() async {
//    var getmessages = await _fireStore.collection('messages').getDocuments();
//    for (var newMessages in getmessages.documents) {
//      print(newMessages.data);
//    }
//  }
//  void streamData() async {
//    await for (var snapShot in _fireStore.collection('messages').snapshots()) {
//      messagesList.clear();
//      for (var newMessages in snapShot.documents) {
//        print(newMessages.data);
//        setState(() {
//          messagesList.add(Text(newMessages.data.toString()));
//        });
//      }
//    }
//    ;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                final messages = snapshot.data.documents.reversed;
                List<MessageBubble> messageList = [];
                for (var loopMessage in messages) {
                  final messageText = loopMessage.data['text'];
                  final messageSender = loopMessage.data['sender'];
                  final currentUser = loginUser.email;
                  messageList.add(MessageBubble(
                    text: messageText,
                    sender: messageSender,
                    isMe: messageSender == currentUser,
                  ));
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: messageList,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                      _fireStore.collection('messages').add({
                        'sender': "${loginUser.email}",
                        'text': "$message",
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(30) : Radius.circular(0),
                topRight: isMe ? Radius.circular(0) : Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            elevation: 3.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "$text ",
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
