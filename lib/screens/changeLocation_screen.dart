import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../providers/labs.dart';

class ChangeLocationScreen extends StatefulWidget {
  @override
  _ChangeLocationScreenState createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  String _labName;

  @override
  void initState() {
    super.initState();
    syspaths.getApplicationDocumentsDirectory().then((appDir) {
      final filehandler = File('${appDir.path}/Lab.txt');
      filehandler.readAsString().then((name) {
        setState(() {
          _labName = name;
        });
      });
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filehandler = File('${appDir.path}/Lab.txt');
    _labName = await filehandler.readAsString();
  }

  void _setLabName() async {
    final directory = await syspaths.getApplicationDocumentsDirectory();
    final filehandler = File('${directory.path}/Lab.txt');
    filehandler.writeAsString(_labName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 5,
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Please select your location: '),
                ),
                SizedBox(height: 30,),
                DropdownButton<String>(
                  value: _labName,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  isDense: true,
                  isExpanded: false,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _labName = newValue;
                      _setLabName();
                    });
                  },
                  items:
                      listOfLabs.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
