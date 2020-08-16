import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/screens/login_screen.dart';
import 'package:groupchat/screens/mobilelogin/mobilesign.dart';
import 'package:groupchat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
//import 'package:connectivity/connectivity.dart';
import 'buttons.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription streamSubscription;
  ConnectivityResult oldresult;
  AnimationController animationController;
  Animation animation;
  void checkconnection() {
    try {
      InternetAddress.lookup("www.google.com").then((result) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        } else {
          showdialog();
        }
      }).catchError((error) {
        showdialog();
      });
    } on SocketDirection catch (_) {
      showdialog();
    }
    streamSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult newresult) {
      if (newresult == ConnectivityResult.none) {
        showdialog();
      } else if (oldresult == ConnectivityResult.none) {
        print("connection");
      }
      oldresult = newresult;
    });
  }

  void showdialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            RaisedButton.icon(
                color: Colors.amber,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel),
                label: Text("Exit"))
          ],
          content: Text("No internet Connection"),
          backgroundColor: Colors.amber,
          title: Text("Check your internet Connection"),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this, //this specify what is going to act as a tricker
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.slowMiddle);
    //when we use curved animation thereshouldnt be upperbound its max is 0-1

    //animation = ColorTween(begin: Colors.amber, end: Colors.lightBlue)
    // .animate(animationController);
    animationController.forward();
    /*animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        // animationController.forward();
      }
    });*/
    animationController.addListener(() {
      setState(() {});
    });
    checkconnection();
  }

//Animation Automatically doesnot remove we have to dismiss
  @override
  void dispose() {
    streamSubscription.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "Group ChaT",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: animation.value * 30,
              color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.amber,
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Sanjay Thakurathi"),
                accountEmail: Text("Thakurathisanjay@gmail.com"),
                currentAccountPicture: Image.asset("images/profil.jpg"),
                otherAccountsPictures: <Widget>[
                  CircleAvatar(
                      child: Text(
                    "S",
                    style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ))
                ],
                arrowColor: Colors.green[800],
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.lightBlue.withOpacity(animationController.value),//animating image

      backgroundColor:
          Colors.lightBlue.withAlpha(animationController.value.toInt() * 200),
      // Colors.lightBlue,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: animation.value * 120,
                      //we cant use directly value for curved animation
                    ),
                  ),
                ),
                Expanded(
                  child: TyperAnimatedTextKit(
                    //' Group ${animationController.value.toInt()}%',//Text animating
                    text: [
                      'Group ChaT_'
                    ], //here we have to write a text in a list
                    textStyle: TextStyle(
                      //instead of style replace it with textstyle
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Buttons(
              onpressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              color: Colors.amber,
              text: Text(
                "Login with Email",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: animation.value * 25),
              ),
            ),
            /* Buttons(
                color: Colors.green,
                text: Text(
                  "Login with Mobile num",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: animation.value * 25),
                ),
                onpressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Mobilelogin()));
                }),
                */
            Buttons(
              color: Colors.amber,
              onpressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              text: Text(
                "Register Email",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: animation.value * 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
