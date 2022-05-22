import 'package:flutter/material.dart';
import 'package:jalapeno_spices/spice.dart';
import 'package:jalapeno_spices/new_spice.dart';

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
        body: Container(
          // child: Spices(),
          padding: const EdgeInsets.all(8.0),
          child: NewSpiceForm(key: GlobalKey<FormState>()),
        ),
      ),
    );
  }
}

class Spices extends StatefulWidget {
  const Spices({Key? key}) : super(key: key);

  @override
  State<Spices> createState() => _SpicesState();
}

class _SpicesState extends State<Spices> {
  final _spiceList = <Spice>[
    Spice("Onion Powder", DateTime(2022, 9, 22)),
    Spice("Jalapeño Powder", DateTime(2023, 3, 22)),
  ];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index < _spiceList.length)
            return Text(_spiceList[index].name);
          else
            return Text("");
        },
    );
  }
}
