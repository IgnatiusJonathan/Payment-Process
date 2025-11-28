import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite3.dart';
import 'package:sqlite_async/sqlite_async.dart';

final databaseProvider = FutureProvider<Database>(
  (ref) async {
    final db = Database();
    await db.init();
    return db;
  },
);

class Database {
  late SqliteDatabase _db;

  final _migrations = SqliteMigrations()
    ..add(SqliteMigration(
      1,
      (tx) async {
        await tx.execute(""" CREATE TABLE IF NOT EXISTS USERS (
          userID integer NOT NULL PRIMARY KEY AUTOINCREMENT,
          username VARCHAR(255) NOT NULL,
          password VARCHAR(255) NOT NULL,
          totalSaldo integer NOT NULL
        ) """);
      },
    ));

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, 'tcg.db');

    _db = SqliteDatabase(path: path);
    _migrations.migrate(_db);
  }

  void close() async {
    await _db.close();
  }

  Future<dynamic> execute(String sql,
      [List<Object?> parameters = const []]) async {
    return _db.execute(sql, parameters);
  }

  Future<dynamic> get(String sql, [List<Object?> parameters = const []]) async {
    return _db.get(sql, parameters);
  }

  Future<dynamic> delete(String sql, [List<Object?> parameters = const []]) async {
    await _db.execute(sql, parameters);
  }

  Future<dynamic> getAll(String sql,
      [List<Object?> parameters = const []]) async {
    return _db.getAll(sql, parameters);
  }

  Future<dynamic> writeTransaction(callback) async {
    await _db.writeTransaction(callback);
  }

  Stream<ResultSet> watch(
    String sql, {
    List<Object?> parameters = const [],
    Duration throttle = const Duration(milliseconds: 30),
    Iterable<String>? triggerOnTables,
  }) {
    return _db.watch(
      sql,
      parameters: parameters,
      throttle: throttle,
      triggerOnTables: triggerOnTables,
    );
  }
}
