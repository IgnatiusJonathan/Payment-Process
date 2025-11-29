import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final int userID;
  final String username;
  final int totalSaldo;
  UserState({required this.userID, required this.username, required this.totalSaldo});

  UserState copyWith({int? totalSaldo}) {
    return UserState(
      userID: userID,
      username: username,
      totalSaldo: totalSaldo ?? this.totalSaldo,
    );
  }
}

class UserNotifier extends StateNotifier<UserState?> {
  UserNotifier() : super(null);

  void setUser(UserState user) => state = user;

  void topUp(int amount) {
    if (state != null) {
      state = state!.copyWith(
      totalSaldo: state!.totalSaldo + amount,
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState?>(
  (ref) => UserNotifier(),
);
