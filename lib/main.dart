import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/screens/chat_screen.dart';
import 'package:groupchat/screens/login_screen.dart';
import 'package:groupchat/screens/registration_screen.dart';
import 'package:groupchat/screens/welcome_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen
          .id, //when we use initialroute we cant use home proprty they do the same
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
