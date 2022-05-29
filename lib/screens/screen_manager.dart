import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './spices_screen/spices_home_screen.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({Key? key}) : super(key: key);

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int _selectedIndex = 0;
  static const page = SpicesHomeScreen();
  static const String prefSelectedIndexKey = 'selectedIndex';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page,
    );
  }
}
