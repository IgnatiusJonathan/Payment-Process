import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/user_repository.dart';

class UserState {
  final int userID;
  final String username;
  final int totalSaldo;
  final String email;
  final String phone;
  final String profileImage;

  UserState({
    required this.userID,
    required this.username,
    required this.totalSaldo,
    this.email = '',
    this.phone = '',
    this.profileImage = '',
  });

  UserState copyWith({
    int? totalSaldo,
    String? email,
    String? phone,
    String? username,
    String? profileImage,
  }) {
    return UserState(
      userID: userID,
      username: username ?? this.username,
      totalSaldo: totalSaldo ?? this.totalSaldo,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class UserNotifier extends StateNotifier<UserState?> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(null);

  void setUser(UserState user) => state = user;

  void logout() => state = null;

  Future<void> updateUsername(String newUsername) async {
    if (state != null) {
      state = state!.copyWith(username: newUsername);
      await _repository.updateUsername(state!.userID, newUsername);
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    if (state != null) {
      state = state!.copyWith(profileImage: imagePath);
      await _repository.updateProfileImage(state!.userID, imagePath);
    }
  }

  Future<void> topUp(int amount) async {
    if (state != null) {
      final newSaldo = state!.totalSaldo + amount;

      state = state!.copyWith(
        totalSaldo: newSaldo,
      );

      await _repository.updateSaldo(state!.userID, newSaldo);
    }
  }

  Future<bool> decrementSaldo(int amount) async {
    if (state != null) {
      if (state!.totalSaldo < amount) {
        return false;
      }

      final newSaldo = state!.totalSaldo - amount;

      state = state!.copyWith(
        totalSaldo: newSaldo,
      );

      await _repository.updateSaldo(state!.userID, newSaldo);
      return true;
    }
    return false;
  }

  Future<bool> validatePassword(String inputPassword) async {
    if (state != null) {
      final userMap = await _repository.getUser(state!.username);
      if (userMap != null && userMap['password'] == inputPassword) {
        return true;
      }
    }
    return false;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState?>(
  (ref) {
    final repository = ref.watch(userRepositoryProvider);
    return UserNotifier(repository);
  },
);
