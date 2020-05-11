import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../screens/scan_screen.dart';

class ChooseLab extends StatefulWidget {
  String _labName;
  ChooseLab(this._labName);

  @override
  _ChooseLabState createState() => _ChooseLabState();
}

class _ChooseLabState extends State<ChooseLab> {
  List<String> listOfLabs = ['Lab1', 'Lab2', 'Lab3'];
  @override
  void didChangeDependencies() async {
    
    super.didChangeDependencies();
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filehandler = File('${appDir.path}/Lab.txt');
    widget._labName = await filehandler.readAsString();
  }

  void _setLabName() async {
    final directory = await syspaths.getApplicationDocumentsDirectory();
    final filehandler = File('${directory.path}/Lab.txt');
    filehandler.writeAsString(widget._labName);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Please select your location: '),
            ),
            color: Theme.of(context).primaryColor,
          ),
          DropdownButton<String>(
            value: widget._labName,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (String newValue) {
              setState(() {
                widget._labName = newValue;
                _setLabName();
              });
            },
            items: listOfLabs.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // SizedBox(
          //   width: 30,
          // ),
          IconButton(
            icon: Icon(Icons.keyboard_return),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ScanScreen.routeName);
            },
            tooltip: 'Back',
          )
        ]);
  }
}
