import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Jalapeño Spcices',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jalapeño Spcices'),
        ),
        body: const Center(
          child: Text('What\'s on the spice rack?'),
        ),
      ),
    );
  }
}
