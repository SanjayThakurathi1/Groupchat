/*import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupchat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
//import 'package:form_field_validator/form_field_validator.dart';

class Mobilelogin extends StatefulWidget {
  @override
  _MobileloginState createState() => _MobileloginState();
}

class _MobileloginState extends State<Mobilelogin> {
  //var  _formKey = GlobalKey<FormState>();
  bool spinner = false;

  var _form = GlobalKey<FormState>();
  bool _flip = true;
  bool loading = false;
  void _toggle() {
    setState(() {
      _flip = !_flip;
    });
  }

  String er = "";
  final _phonecontroller = TextEditingController();

  var val;
  Future<bool> mobilelogin(String phone, BuildContext context) async {
    final _codecontroller = TextEditingController();

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        //nside it we recieve from firebase auth credential which we can use to sign in user account and it is only get called when verificaltion is done using autoretrivial not by manually
        verificationCompleted: (AuthCredential credential) async {
          Navigator.pop(context);
          var result = await _auth.signInWithCredential(credential);
          //now get the currently logged in user by firebase
          FirebaseUser user = result.user;
          //now we to pass this user to homescreen  for phone num for this
          try {
            if (user != null) {
              Navigator.pushNamed(context, ChatScreen.id);
            }
          } catch (e) {
            print(e.toString());
          }
        },
        verificationFailed: (AuthException exception) {
          print(exception.toString());
        },
        codeSent: (String verificationid, [int forceresendingtoken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.amber,
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                title: Text("Enter verification code"),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _form,
                      child: TextFormField(
                        obscureText: false,
                        autovalidate: true,
                        validator: (val) =>
                            val.length < 5 ? "Enter a 6 digit code" : null,
                        controller: _codecontroller,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(FontAwesomeIcons.eye),
                            onPressed: () {
                              loading = false;
                              setState(() {
                                _toggle();
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "Enter code",
                        ),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      highlightColor: Colors.amber,
                      splashColor: Colors.amber,
                      color: Colors.black,
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        //now we make auth credential id by verification id
                        String code = _codecontroller.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationid, smsCode: code);

                        //Now we use  do thing  now lets sign in using credential
                        try {
                          AuthResult result =
                              await _auth.signInWithCredential(credential);
                          FirebaseUser user = result.user;

                          if (user != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        } catch (e) {
                          //String  errorr = e.toString();
                          er = e.toString();
                          if (er != null) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      " code wrong ? please reenter the code "),
                                  actions: <Widget>[
                                    RaisedButton(
                                        color: Colors.green,
                                        child: Text("Continue"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }),
                ],
              );
            },
          );
        },
        codeAutoRetrievalTimeout: null);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text("Sign in using mobile num"),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Form(
          // key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextFormField(
                    autovalidate: true,
                    validator: (val) =>
                        val.length < 10 ? "Enter num with country code" : null,
                    obscureText: _flip ? true : false,
                    controller: _phonecontroller,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _toggle();
                              });
                            },
                            icon: Icon(FontAwesomeIcons.eye)),
                        hintText: "Enter Mobile number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: 200,
                    height: 40,
                    child: RaisedButton(
                      splashColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.amber,
                      onPressed: () {
                        setState(() {
                          spinner = true;
                        });
                        mobilelogin(_phonecontroller.text.trim(), context);
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
