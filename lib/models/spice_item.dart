import 'dart:convert';

import 'package:intl/intl.dart';

class SpiceItem {
  String? id;
  final String name;
  final DateTime expiration_date;
  final bool is_low;

  SpiceItem({
    this.id,
    required this.name,
    required this.expiration_date,
    this.is_low = false,
  });

  SpiceItem copyWith({
    String? id,
    String? name,
    DateTime? expiration_date,
    bool? is_low,
  }) {
    return SpiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      expiration_date: expiration_date ?? this.expiration_date,
      is_low: is_low ?? this.is_low,
    );
  }

  factory SpiceItem.fromMap(Map<String, dynamic> json) => SpiceItem(
    id: json['id'].toString(),
    name: json['name'],
    expiration_date: DateTime.parse(json['expiration_date']),
    is_low: (json['is_low'] == 1),
  );

  static Map<String, dynamic> toMap(SpiceItem spiceItem) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = spiceItem.id;
    data['name'] = spiceItem.name;
    data['expiration_date'] = spiceItem.expiration_date;
    data['is_low'] = spiceItem.is_low;

    return data;
  }

  static String dateToString(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static Map<String, dynamic> toDbMap(SpiceItem spiceItem) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = spiceItem.id == "0"? null : spiceItem.id;
    data['name'] = spiceItem.name;
    data['expiration_date'] = dateToString(spiceItem.expiration_date);
    data['is_low'] = spiceItem.is_low? 1 : 0;

    return data;
  }

  static String encode(List<SpiceItem> spiceItems) => json.encode(
    spiceItems.map<Map<String, dynamic>>((spiceItem) => SpiceItem.toDbMap(spiceItem)).toList(),
  );

  static List<SpiceItem> decode(String spiceItems) => (json.decode(spiceItems) as List<dynamic>).map<SpiceItem>((item) => SpiceItem.fromMap(item)).toList();
}