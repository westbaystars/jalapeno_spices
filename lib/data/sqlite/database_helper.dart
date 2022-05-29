/*
 * Much of this database functionality was borrowed from
 * https://github.com/holusojivhictor/gigi_Spices
 */

import 'package:jalapeno_spices/models/spice_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:jalapeno_spices/models/models.dart';

class DatabaseHelper {
  static const _databaseName = 'JalapenoSpices.db';
  static const _databaseVersion = 1;

  static const spiceTable = 'spices';

  static late BriteDatabase _streamDatabase;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static var lock = Lock();

  static Database? _database;

  // SQL code to create the database tables

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $spiceTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            expiration_date TEXT,
            is_low INTEGER default 0
          );
          INSERT INTO $spiceTable values (
            null, 'Onion Powder', '2022-09-22', 0
          );
          INSERT INTO $spiceTable values (
            null, 'Garlic Powder', '2022-11-22', 0
          );
          ''');
  }

  // This opens the database (and creates it if it doesn't already exist)

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, _databaseName);

    // Remember to turn off debugging before deploying to app store(s)
    Sqflite.setDebugModeOn(false);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Use this object to prevent concurrent access to data

    await lock.synchronized(() async {
      // lazily instantiate the db the first time it is launched

      if (_database == null) {
        _database = await _initDatabase();

        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<SpiceItem> parseSpiceItem(List<Map<String, dynamic>> SpiceList) {
    final Spices = <SpiceItem>[];

    SpiceList.forEach((spiceMap) {
      final spice = SpiceItem.fromMap(spiceMap);

      Spices.add(spice);
    });
    return Spices;
  }

  Future<List<SpiceItem>> findAllSpices() async {
    final db = await instance.streamDatabase;

    final spiceList = await db.query(spiceTable);
    final spices = parseSpiceItem(spiceList);
    return spices;
  }

  Stream<List<SpiceItem>> watchAllSpices() async* {
    final db = await instance.streamDatabase;

    yield* db.createQuery(spiceTable).mapToList((row) => SpiceItem.fromMap(row));
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;

    return db.insert(table, row);
  }


  Future<int> insertSpice(SpiceItem spiceItem) {
    return insert(spiceTable, SpiceItem.toDbMap(spiceItem));
  }

  Future<int> update(String table, Map<String, dynamic> row, String columnId,
      String id) async {
    final db = await instance.streamDatabase;

    return db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateSpice(SpiceItem spiceItem) async {
    if (spiceItem.id != null) {
      return update(
          spiceTable, SpiceItem.toMap(spiceItem), 'id', spiceItem.id!);
    } else {
      return Future.value(-1);
    }
  }

  Future<int> _delete(String table, String columnId, String id) async {
    final db = await instance.streamDatabase;

    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteSpice(SpiceItem spiceItem) async {
    if (spiceItem.id != null) {
      return _delete(spiceTable, 'id', spiceItem.id!);
    } else {
      return Future.value(-1);
    }
  }

  void close() {
    _streamDatabase.close();
  }
}
