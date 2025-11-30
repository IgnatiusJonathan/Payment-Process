import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(databaseProvider).value;
  return UserRepository(db!);
});

class UserRepository {
  final Database db;
  UserRepository(this.db);

  Future<int> createUser(String username, String password, String email, String phone) async {
    final result = await db.execute(
      "INSERT INTO USERS (username, password, email, phone, totalSaldo) VALUES (?, ?, ?, ?, ?)",
      [username, password, email, phone, 0],
    );
    return result.insertId;
  }

  Future<Map<String, Object?>?> getUser(String username) async {
    return await db.get(
      "SELECT * FROM USERS WHERE username = ?",
      [username],
    );
  }

  Future<Map<String, Object?>?> getUserByIdentifier(String identifier) async {
    final result = await db.getAll(
      "SELECT * FROM USERS WHERE email = ? OR phone = ?",
      [identifier, identifier],
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> updateSaldo(int userID, int newSaldo) async {
    await db.execute(
      "UPDATE USERS SET totalSaldo = ? WHERE userID = ?",
      [newSaldo, userID],
    );
  }

  Future<void> updateUsername(int userID, String newUsername) async {
    await db.execute(
      "UPDATE USERS SET username = ? WHERE userID = ?",
      [newUsername, userID],
    );
  }

  Future<void> updateProfileImage(int userID, String imagePath) async {
    await db.execute(
      "UPDATE USERS SET profileImage = ? WHERE userID = ?",
      [imagePath, userID],
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
