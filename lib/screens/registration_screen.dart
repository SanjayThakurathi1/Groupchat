import 'package:flutter/material.dart';
import 'package:groupchat/constants.dart';
import 'package:groupchat/screens/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupchat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:form_field_validator/form_field_validator.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/register_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey _globalKey = GlobalKey();

  bool showindicator = false;
  String email, password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool seepassword = true;

  void toggle() {
    setState(() {
      seepassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showindicator,
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
                key: _globalKey,
                child: TextFormField(
                    validator: (value) =>
                        value.isEmpty ? "Enter valid Email" : null,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextfieldDecoration.copyWith(
                      hintText: "Enter your Email",
                    )),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                  child: TextFormField(
                autovalidate: true,
                validator: (value) =>
                    value.length < 6 ? "Enter a password with 8+ char" : null,
                textAlign: TextAlign.center,
                obscureText: seepassword,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextfieldDecoration.copyWith(
                    hintText: "Enter password",
                    prefixIcon: IconButton(
                      onPressed: () => toggle(),
                      icon: Icon(Icons.remove_red_eye),
                    )),
              )),
              SizedBox(
                height: 24.0,
              ),
              Buttons(
                  text: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.lightBlue,
                  onpressed: () async {
                    try {
                      setState(() {
                        showindicator = true;
                      });
                      dynamic result =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (result != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showindicator = false;
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
