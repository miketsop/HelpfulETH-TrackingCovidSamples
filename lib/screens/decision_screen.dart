import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './auth_screen.dart';
import './main_screen.dart';

class DecisionScreen extends StatelessWidget {
  static const routeName = '/decision-screen';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = userSnapshot.data;
          print(user);
          if (user == null) {
            return AuthScreen();
          }
          return MainScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
