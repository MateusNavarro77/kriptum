import 'package:kriptum/infra/persistence/database/sqflite/migrations/migrations_1.dart';
import 'package:kriptum/infra/persistence/database/sqflite/migrations/migrations_2.dart';
import 'package:kriptum/infra/persistence/database/sqflite/migrations/migrations_3.dart';
import 'package:kriptum/infra/persistence/database/sqflite/migrations/migrations_4.dart';
import 'package:kriptum/infra/persistence/database/sqflite/migrations/migrations_5.dart';
import 'package:sqflite/sqflite.dart';

Future<void> runMigrations(Database db, int oldVersion, int newVersion) async {
  final Map<int, Future<void> Function(Database)> migrations = {
    1: runMigration1,
    2: runMigration2,
    3: runMigration3,
    4: runMigration4,
    5: runMigration5,
  };

  for (var version = oldVersion + 1; version <= newVersion; version++) {
    final migration = migrations[version];
    if (migration != null) {
      await migration(db);
    }
  }
}
