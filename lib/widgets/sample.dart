import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sample extends StatelessWidget {
  final Map<String, Object> sample;
  Sample(this.sample);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(sample['timestamp']);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.assignment),
        // leading: Icon(Icons.healing),
        // leading: Icon(Icons.local_hospital),
        title: Text('Sample ID : ${sample['barcodeText']}'),
        subtitle: Text('${DateFormat.yMMMd().format(date)}, at ${DateFormat.Hms().format(date)}'),
        trailing: Text('${sample['labName']}'),
      ),
    );
  }
}
