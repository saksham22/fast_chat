import 'package:fast_chat/screens/login_screen.dart';
import 'package:fast_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fast_chat/components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {

  static String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation ani;
  @override
  void initState() {
    super.initState();
    startFirebase();
    controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    ani=ColorTween(begin: Colors.red,end: Colors.white).animate(controller);
//    ani= CurvedAnimation(parent: controller,curve:Curves.decelerate );
//    ani.addStatusListener((status) {
//      if(status==AnimationStatus.completed){
//        controller.reverse(from: 1.0);
//      }else if (status==AnimationStatus.dismissed){
//        controller.forward();
//      }
//    });
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
//      print(ani.value);
    });
  }
  Future startFirebase() async {
    await Firebase.initializeApp();
    print('Firebase initialized');
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ani.value,
//      backgroundColor: Colors.red.withOpacity(controller.value),
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
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
//                    child: Icon(Icons.desktop_mac),
                      height: 60,

                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: ['Fast Chat'],
                    textStyle: TextStyle(fontSize: 40.0, fontFamily: "Horizon"),
//                    textAlign: TextAlign.start,
//                    alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(name:'Log In',func:() {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            colour: Colors.lightBlueAccent,),
            RoundedButton(name: 'Register',
              func: () {
            Navigator.pushNamed(context, RegistrationScreen.id);
            },
            colour: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

