import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(databaseProvider).value;
  return UserRepository(db!);
});

class UserRepository {
  final Database db;
  UserRepository(this.db);

  Future<int> createUser(String username, String password) async {
    final result = await db.execute(
      "INSERT INTO USERS (username, password, totalSaldo) VALUES (?, ?, ?)",
      [username, password, 0],
    );
    return result.insertId;
  }

  Future<Map<String, Object?>?> getUser(String username) async {
    return await db.get(
      "SELECT * FROM USERS WHERE username = ?",
      [username],
    );
  }

  Future<void> updateSaldo(int userID, int newSaldo) async {
    await db.execute(
      "UPDATE USERS SET totalSaldo = ? WHERE userID = ?",
      [newSaldo, userID],
    );
  }

  Future<List<Map<String, Object?>>> getAllUsers() async {
    try {
      final result = await db.getAll("SELECT * FROM USERS");
      return result;
    } catch (e) {
      print("Error getting all users: $e");
      return [];
    }
  }
}
