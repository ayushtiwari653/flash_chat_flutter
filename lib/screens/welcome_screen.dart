import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import '../components/Cards.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    //animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    animation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(controller);
    controller.forward();
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'hero',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textAlign: TextAlign.start,
                  speed: Duration(seconds: 1),
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 45.0,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedLoadingButton(
              child: Text('Login', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            SizedBox(
              height: 20,
            ),
            RoundedLoadingButton(
              child: Text('Register', style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            )
//            NewCards(
//                text: "Login",
//                color: Colors.lightBlueAccent,
//                newMethod: () {
//                  Navigator.pushNamed(context, LoginScreen.id);
//                }),
//            NewCards(
//                text: "Register",
//                color: Colors.blueAccent,
//                newMethod: () {
//                  Navigator.pushNamed(context, RegistrationScreen.id);
//                })
          ],
        ),
      ),
    );
  }
}
