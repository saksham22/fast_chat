import 'package:fast_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fast_chat/components/rounded_button.dart';
import 'package:fast_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget {
  static String id='registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool spin=false;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spin,
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
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password=value;
                },
                decoration: kTextField.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(name: 'Register',func: ()async {
                print(email);
                print(password);

                setState(() {
                  spin=true;
                });
                try
{
  final newUser=await _auth.createUserWithEmailAndPassword(email: email, password: password);
  if(newUser!=null){
    Navigator.pushNamed(context, ChatScreen.id);
  }
}
catch(e){
  print(e);
}
                setState(() {
                  spin=false;
                });
},colour: Colors.blueAccent,),
            ],
          ),
        ),
      ),
    );
  }
}
