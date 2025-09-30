import 'package:flutter/material.dart';
void main() => runApp(MoodMapperApp());

class MoodMapperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodMapper',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(child: Text('MoodMapper Flutter skeleton - implement UI here')),
      ),
    );
  }
}
