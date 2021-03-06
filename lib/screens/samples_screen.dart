import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/sample.dart';
import '../widgets/main_drawer.dart';

class SamplesScreen extends StatefulWidget {
  static const routeName = '/samples-screen';
  @override
  _SamplesScreenState createState() => _SamplesScreenState();
}

class _SamplesScreenState extends State<SamplesScreen> {

  void _onBackPressed(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: _onBackPressed),
          title: const Text('List of COVID samples'),
        ),
        drawer: MainDrawer(),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('samples')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final samples = snapshot.data.documents;
            if (samples.length == 0){
              return Center(child: const Text('No samples added yet!'));
            }
            return ListView.builder(
              itemCount: samples.length,
              itemBuilder: (ctx, indx) => Sample(samples[indx].data),
            );
          },
        ),
    );
  }
}
