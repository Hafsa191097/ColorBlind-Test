import 'package:flutter/material.dart';

import '../Auth/auth.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: FloatingActionButton(
          onPressed: (){
            AuthService().signOut();
          },
          child: Icon(Icons.logout_rounded, color: Colors.white, size: 20),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
          ),
      ),
    );
  }
}
