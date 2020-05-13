import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helpfulETH_TrackingCovidSamples/screens/decision_screen.dart';

import './screens/auth_screen.dart';
import './screens/scan_screen.dart';
import './screens/samples_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpfulETH - Tracking samples',
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme.of(context).copyWith(
          color: Colors.red,
        ),
        primarySwatch: Colors.red,
        backgroundColor: Colors.red,
        accentColor: Colors.redAccent,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.red,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: DecisionScreen(),
      routes: {
        SamplesScreen.routeName: (ctx) => SamplesScreen(),
        ScanScreen.routeName: (ctx) => ScanScreen(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        DecisionScreen.routeName: (ctx) => DecisionScreen(),
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
        return MaterialPageRoute(builder: (ctx) => AuthScreen());
      },
      //* This page below will be loaded as a fallback if also onGenerateRoute fails!
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => AuthScreen());
      },
    );
  }
}
