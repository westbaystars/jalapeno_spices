import 'dart:async';

import './database_helper.dart';
import '../repository.dart';
import '../../models/models.dart';

class SqliteRepository extends Repository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<List<SpiceItem>> findAllSpices() {
    return dbHelper.findAllSpices();
  }

  @override
  Stream<List<SpiceItem>> watchAllSpices() {
    return dbHelper.watchAllSpices();
  }

  @override
  Future<int> insertSpice(SpiceItem spiceItem) {
    return Future(() async {
      final id = await dbHelper.insertSpice(spiceItem);

      return id;
    });
  }

  @override
  Future<int> updateSpice(SpiceItem spiceItem) {
    return Future(() async {
      final id = await dbHelper.updateSpice(spiceItem);

      return id;
    });
  }

  @override
  Future<void> deleteSpice(SpiceItem spiceItem) {
    dbHelper.deleteSpice(spiceItem);

    return Future.value();
  }

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }
}
