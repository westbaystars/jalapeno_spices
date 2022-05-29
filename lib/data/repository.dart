import '../models/spice_item.dart';

abstract class Repository {

  Stream<List<SpiceItem>> watchAllSpices();

  Future<List<SpiceItem>> findAllSpices();

  Future<int> insertSpice(SpiceItem spiceItem);

  Future<int> updateSpice(SpiceItem spiceItem);

  Future<void> deleteSpice(SpiceItem spiceItem);

  Future init();

  void close();
}