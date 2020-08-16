import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

//import 'package:flash_chat/constants.dart';
final _messageTextController = TextEditingController();
FirebaseUser loggedin;
bool isMe;
String userr;

class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Firestore _firestore = Firestore.instance;
  String messagetext;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future getcurrentuser() async {
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loggedin = user;
        print(loggedin.email);
        print(loggedin.phoneNumber);
        print("userr is$userr");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //void getmesseges() async {
  // final messeges = await _firestore.collection("messeges").getDocuments();
  // for (var msg in messeges.documents) {
  //  print(msg.data);
  //  } //here messeges.document has a list and we have to access individuals
  // }

  //using Stream for automatically listen
  void getmesseges() async {
    await for (var msgsnapshot in _firestore
        .collection("messages")
        .snapshots()) // for getting msg automatically
    {
      for (var msg in msgsnapshot.documents) {
        print(msg.data);
      }
    }
  }

  @override
  void initState() {
    getcurrentuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          RaisedButton.icon(
              color: Colors.lightBlueAccent,
              label: Text("LogOut"),
              icon: Icon(
                Icons.person,
              ),
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
                stream: _firestore.collection("messages").snapshots(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  {
                    final messages = snapshot.data.documents;
                    final List<Showmsg> messagewidgets = [];
                    for (var msg in messages) {
                      final messagetext = msg.data['text'];
                      final msgsender = msg.data['sender'];
                      final currentUser = loggedin.email;
                      userr = msgsender;

                      final msgWidget = Showmsg(
                        msgtxt: messagetext,
                        sender: msgsender,
                        isMe: currentUser == msgsender,
                      );

                      //to add in list
                      messagewidgets.add(msgWidget);
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        children: messagewidgets,
                      ),
                    );
                  }
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _messageTextController,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _messageTextController.clear();
                      _firestore.collection("messages").add({
                        "text": messagetext,
                        /* "sender": userr == loggedin.phoneNumber
                            ? loggedin.phoneNumber
                            : loggedin.email
  */
                        "sender": loggedin.email,
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

class Showmsg extends StatelessWidget {
  final String msgtxt;
  final String sender;
  final bool isMe;

  Showmsg({
    this.msgtxt,
    this.sender,
    this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender
            ,
            textAlign: TextAlign.end,
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(50),
                    topLeft: Radius.circular(40))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(40),
                  ),
            elevation: 6.0,
            color: isMe ? Colors.amber : Colors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("$msgtxt",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
