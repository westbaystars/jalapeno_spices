import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'spice_item.dart';

class SpiceManager extends ChangeNotifier {
  List<SpiceItem> _spiceItems = <SpiceItem>[];
  int _selectedIndex = -1;
  bool _createNewItem = false;

  List<SpiceItem> get spiceItems => List.unmodifiable(_spiceItems);

  int get selectedIndex => _selectedIndex;
  SpiceItem? get selectedSpiceItem => _selectedIndex != -1 ? _spiceItems[_selectedIndex] : null;
  bool get isCreatingNewItem => _createNewItem;
  static const String prefSpiceKey = 'spicesKey';

  bool get darkMode => false;


  void saveOldSpices() async {
    final prefs = await SharedPreferences.getInstance();

    String encodedData = SpiceItem.encode(_spiceItems);

    prefs.setString(prefSpiceKey, encodedData);
  }

  void getOldSpices() async {
    final prefs = await SharedPreferences.getInstance();

    final oldSpices = prefs.getString(prefSpiceKey);

    if (oldSpices != null) {
      List<SpiceItem> spiceItemSaved = SpiceItem.decode(oldSpices);

      _spiceItems = spiceItemSaved;
    }
  }

  void createNewItem() {
    _createNewItem = true;
    notifyListeners();
  }

  void deleteItem(int index) {
    _spiceItems.removeAt(index);
    notifyListeners();
  }

  void spiceItemTapped(int index) {
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void setSelectedSpiceItem(String id) {
    final index = spiceItems.indexWhere((element) => element.id == id);
    _selectedIndex = index;
    _createNewItem = false;
    notifyListeners();
  }

  void addItem(SpiceItem item) {
    _spiceItems.add(item);
    _createNewItem = false;
    notifyListeners();
  }

  void updateItem(SpiceItem item, int index) {
    _spiceItems[index] = item;
    _selectedIndex = -1;
    _createNewItem = false;
    notifyListeners();
  }

  void lowItem(int index, bool change) {
    final item = _spiceItems[index];
    _spiceItems[index] = item.copyWith(is_low: change);
    notifyListeners();
  }
}