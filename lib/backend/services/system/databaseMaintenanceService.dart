import 'package:isar_community/isar.dart';

class DatabaseMaintenanceService {
  final Isar isar;

  DatabaseMaintenanceService(this.isar);

  /// Clears all data from the database.
  /// This will remove all entries from all collections.
  Future<void> clearAllData() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
