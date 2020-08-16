import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/constants.dart';
import 'package:groupchat/screens/buttons.dart';

import 'package:groupchat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool changeeye = true;
  void toggle() {
    setState(() {
      changeeye = false;
    });
  }

  GlobalKey _globalKey = GlobalKey();
  bool showspinner = false;
  String email, password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Form(
                autovalidate: true,
                key: _globalKey,
                child: TextFormField(
                    
                    validator: (value) =>
                        value.isEmpty ? "Enter Email address" : null,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextfieldDecoration.copyWith(
                      hintText: 'Enter your Email',
                    )),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                autovalidate: true,
                child: TextFormField(
                    validator: (value) => value.length < 8
                        ? "Enter password with 8+ character"
                        : null,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.center,
                    obscureText: changeeye,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextfieldDecoration.copyWith(
                      prefixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () => toggle(),
                      ),
                      hintText: 'Enter your password',
                    )),
              ),
              SizedBox(
                height: 24.0,
              ),
              Buttons(
                  color: Colors.lightBlueAccent,
                  text: Text("Login"),
                  onpressed: () async {
                    try {
                      setState(() {
                        showspinner = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (result != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showspinner = false;
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
