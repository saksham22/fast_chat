import 'package:fast_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:fast_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showspinner=false;

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
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email=value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {

                  password=value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your password.'),
              ),
              SizedBox(
                height: 24.0,
              ),

              RoundedButton(name: 'Log In',func: ()async {
                setState(() {
                  showspinner=true;
                });
                try
                {
                  final signin=await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(signin!=null){
                    print(signin);
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }
                catch(e){
                  print(e);
                }
                setState(() {
                  showspinner=false;
                });
              },colour: Colors.lightBlueAccent,)
            ],
          ),
        ),
      ),
    );
  }
}
