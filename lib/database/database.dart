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
          totalSaldo integer NOT NULL,
          isLoggedIn INTEGER DEFAULT 0
        ) """);
      },
    ))
    ..add(SqliteMigration(
      2,
      (tx) async {
        await tx.execute(""" CREATE TABLE IF NOT EXISTS HISTORY (
          HistoryID integer NOT NULL PRIMARY KEY AUTOINCREMENT,
          userID integer NOT NULL,
          Recepient VARCHAR(255) NOT NULL,
          timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (userID) REFERENCES USERS(userID)
        ) """);
      },
    ))
    ..add(SqliteMigration(
      3,
      (tx) async {
        await tx.execute("ALTER TABLE HISTORY ADD COLUMN amount INTEGER DEFAULT 0");
        await tx.execute("ALTER TABLE HISTORY ADD COLUMN type TEXT DEFAULT 'payment'");
        await tx.execute("ALTER TABLE HISTORY ADD COLUMN description TEXT DEFAULT ''");
      },
    ))
    ..add(SqliteMigration(
      4,
      (tx) async {
        await tx.execute("ALTER TABLE USERS ADD COLUMN email TEXT DEFAULT ''");
        await tx.execute("ALTER TABLE USERS ADD COLUMN phone TEXT DEFAULT ''");
      },
    ))
    ..add(SqliteMigration(
      5,
      (tx) async {
        await tx.execute("ALTER TABLE USERS ADD COLUMN profileImage TEXT DEFAULT ''");
      },
    ));

  Future<void> init() async {
    print("Database: Initializing...");
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, 'scannabit.db');
    print("Database: Path: $path");

    _db = SqliteDatabase(path: path);
    print("Database: Running migrations...");
    try {
      await _migrations.migrate(_db);
      print("Database: Migrations completed.");
    } catch (e) {
      print("Database: Migration failed: $e");
      rethrow;
    }
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

  Future<List<Map<String, Object?>>> getAll(String sql,
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
