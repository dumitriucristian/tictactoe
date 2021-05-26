import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Some app',
    home:MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key ? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'some title'),

      ),
    );
  }
}
