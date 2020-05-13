import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../screens/samples_screen.dart';
import './chooseLab.dart';

class MainDrawer extends StatelessWidget {
  Future<String> getLabName() async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filehandler = File('${appDir.path}/Lab.txt');
    return (await filehandler.readAsString());
  }

  void buildModalSheet(BuildContext ctx) async {
    final name = await getLabName();
    await showModalBottomSheet(
      backgroundColor: Theme.of(ctx).backgroundColor,
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: ChooseLab(name),
        );
      },
    );
    Navigator.of(ctx).pop();
    return;
  }

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          //color: Theme.of(ctx).primaryTextTheme.title.color,
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          buildListTile(
            'Samples',
            Icons.list,
            () {
              Navigator.of(context).pushNamed(SamplesScreen.routeName);
            },
          ),
          Divider(),
          buildListTile('Change location', Icons.edit_location, () {
            buildModalSheet(context);
          }),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            'Log out',
            Icons.exit_to_app,
            () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
