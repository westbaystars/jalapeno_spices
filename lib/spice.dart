import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:jalapeno_spices/sqflite_migration/migration_config.dart';
import 'package:jalapeno_spices/sqflite_migration/open_database_with_migration.dart';

final List<String> initialScript = [
  '''
  CREATE TABLE spices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    expiration_date INTEGER NOT NULL
  );
'''
];

final List<String> migrations = [
  '''
  INSERT INTO spices VALUES (name, expiration_date)
    ("Onion Powder", "2022-09-22"),
    ("Jalapeño Powder", "2023-03-22");
  '''
];

final config = MigrationConfig(initializationScript: initialScript, migrationScripts: migrations);
final database = open();

Future<Database> open() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'spice_rack.db');

  return await openDatabaseWithMigration(path, config);
}

// Insert a Spice into the database
Future<void> insertSpice(Spice spice) async {
  // Get a reference to the database.
  final db = await database;

  // Insert the Spice into the spices table.
  // Replace any prevous data.
  await db.insert(
    'spices',
    spice.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Retrieve all the spices from the spices table.
Future<List<Spice>> listSpices() async {
  // Get a reference to the database.
  final db = await database;

  // Query the table for all the Spices.
  final List<Map<String, dynamic>> maps = await db.query('spices');

  // Convert the List<Map<String, dynamic> into a List<Spice>.
  return List.generate(maps.length, (i) {
    return new Spice(
      id: maps[i]['id'],
      name: maps[i]['name'],
      expiration_date: maps[i]['expiration_date'],
    );
  });
}

class Spice {
  final int id;
  final String name;
  final DateTime expiration_date;

  const Spice({
    required this.id,
    required this.name,
    required this.expiration_date
  });

  // Convert a Spice into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'expiration_date': expiration_date,
    };
  }

  String getName() { return name; }
  String dateAsString() {
    return DateFormat.yMMMMd().format(expiration_date);
  }

  // Implement toString to make it easier to see informatin about each
  // spice when using the print statement.
  @override
  String toString() {
    return 'Spice{id: $id, name: $name, expiration_date: $expiration_date}';
  }
}