import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/sample.dart';

class SamplesScreen extends StatefulWidget {
  static const routeName = '/samples-screen';
  @override
  _SamplesScreenState createState() => _SamplesScreenState();
}

class _SamplesScreenState extends State<SamplesScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
        if (samples.length == 0) {
          return Center(child: const Text('No samples added yet!'));
        }
        return ListView.builder(
          itemCount: samples.length,
          itemBuilder: (ctx, indx) => Sample(samples[indx].data),
        );
      },
    );
  }
}
