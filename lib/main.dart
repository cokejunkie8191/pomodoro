import 'package:flutter/material.dart';
import 'clock.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ポモドーロタイマー'),
      ),
      body:
          Center(child: Container(alignment: Alignment.center, child: Clock())),
    );
  }
}
