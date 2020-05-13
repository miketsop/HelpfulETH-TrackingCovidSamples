import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './samples_screen.dart';
import './scan_screen.dart';
import './changeLocation_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List <Map<String, Object>> _pages = [
    {
      'page': ScanScreen(),
      'title': 'Scan sample',
    },
    {
      'page': SamplesScreen(),
      'title': 'List of samples',
    },
    {
      'page': ChangeLocationScreen(),
      'title': 'Change location',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
        // leading: Icon(Icons.scanner),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.scanner), title: Text('Scan')),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('Samples')),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_location), title: Text('Change location')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
