import 'package:chat_app/components/rounded_button.dart';
import 'package:chat_app/modules/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = "Login_screen";

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}
//mixin allow class to inherit from more than one class

class _LoginScreen extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child:  Image.asset("images/logo.jfif"),
                    height: 150.0,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {email=value;},
                decoration: TextFieldDecoration.copyWith(hintText: "Enter your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true ,
                textAlign: TextAlign.center,
                onChanged: (value) {password=value;},
                decoration: TextFieldDecoration.copyWith(hintText: "Enter your Password"),
              ),
              RoundedButton(
                onPressedd: () async{
                  try{
                  final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user!=null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }}catch(e){
                    print(e);
                  }
                  },
                title: "Log In",
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ));
  }
}
