import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../widgets/main_drawer.dart';

class ScanScreen extends StatefulWidget {
  static const routeName = '/scan-screen';
  String _labName = 'Unknown';

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String _scanBarcode = 'Unknown';
  var _isUploading = false;

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  void _uploadSample(BuildContext ctx) async {
    setState(() {
      _isUploading = true;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filehandler = File('${appDir.path}/Lab.txt');
    widget._labName = await filehandler.readAsString();
    await Firestore.instance.collection('samples').add({
      'barcodeText': _scanBarcode,
      'labName': widget._labName,
      'timestamp': DateTime.now().toIso8601String(),
    });
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tracking COVID samples'),
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
        drawer: MainDrawer(),
        body: Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_isUploading) Center(child: CircularProgressIndicator()),
              if (!_isUploading)
                RaisedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Text("Start barcode scan"),
                ),
              // RaisedButton(
              //   onPressed: () => scanQR(),
              //   child: Text("Start QR scan"),
              // ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Scan result : $_scanBarcode\n',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (_isUploading ||
                  _scanBarcode.trim().isEmpty ||
                  _scanBarcode.contains('Unknown') ||
                  _scanBarcode.contains('-1'))
              ? null
              : () => _uploadSample(context),
          child: const Icon(Icons.cloud_upload),
          tooltip: 'Upload sample',
        ),
    );
  }
}
