import 'package:kriptum/infra/persistence/database/sql_database.dart';
import 'package:kriptum/infra/persistence/database/sqflite/run_migrations.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class SqfliteDatabase implements SqlDatabase {
  static const _dbVersion = 5;
  final _dbFileName = 'kriptum.db';
  sqflite.Database? _database;
  static final SqfliteDatabase _instance = SqfliteDatabase._internal();
  factory SqfliteDatabase() {
    return _instance;
  }
  SqfliteDatabase._internal();
  Future<sqflite.Database> _getDatabase() async {
    // ignore: prefer_conditional_assignment
    if (_database == null) {
      _database = await _initializeDatabase();
    }
    return _database!;
  }

  Future<sqflite.Database> _initializeDatabase() async {
    String path = await sqflite.getDatabasesPath();
    String dbPath = join(path, _dbFileName);
    return await sqflite.openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await runMigrations(db, 0, _dbVersion);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await runMigrations(db, oldVersion, newVersion);
      },
    );
  }

  @override
  Future<int> delete(
    String table,
    String where,
    List<Object?> whereArgs,
  ) async {
    final db = await _getDatabase();
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await _getDatabase();
    return await db.insert(
      table,
      values,
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> initialize() async {
    await _getDatabase();
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  Future<int> getVersion() async {
    final db = await _getDatabase();
    return await db.getVersion();
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    final db = await _getDatabase();
    return await db.rawQuery(sql, arguments);
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<Object?>? whereArgs}) async {
    final db = await _getDatabase();
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    final db = await _getDatabase();
    return await db.query(
      table,
      distinct: distinct ?? false,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<void> dispose() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  @override
  Future<void> deleteAll(String table) async {
    final db = await _getDatabase();
    await db.delete(table);
  }
}
