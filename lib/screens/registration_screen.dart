import 'package:flash_chat/components/Cards.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RoundedLoadingButtonController _buttonController =
      new RoundedLoadingButtonController();
  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'hero',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: "Enter your Email")),
            SizedBox(
              height: 8.0,
            ),
            TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: "Enter your Password")),
            SizedBox(
              height: 24.0,
            ),
            RoundedLoadingButton(
              child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
              controller: _buttonController,
              onPressed: () async {
                try {
                  final user = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
//            NewCards(
//                text: "Register",
//                color: Colors.blueAccent,
//                newMethod: () async {
//                  try {
//                    final user = await _auth.createUserWithEmailAndPassword(
//                        email: email, password: password);
//                    if (user != null) {
//                      Navigator.pushNamed(context, ChatScreen.id);
//                    }
//                  } catch (e) {
//                    print(e);
//                  }
//                })
          ],
        ),
      ),
    );
  }
}
