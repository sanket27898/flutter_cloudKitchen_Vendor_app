import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vender_app_flutter/screens/register_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RaisedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
        },
        child: Text('Log out'),
      )),
    );
  }
}
