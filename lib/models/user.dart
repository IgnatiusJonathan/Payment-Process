class User {
  final int userId;
  final String username;
  final String password;
  final String email; 
  final String phone; 
  int totalSaldo;     
  bool isLoggedIn;

  User({
    required this.userId,
    required this.username,
    required this.password,
    this.email = '',  
    this.phone = '', 
    required this.totalSaldo,
    this.isLoggedIn = false,
  });

  User copyWith({
    int? userId,
    String? username,
    String? password,
    String? email,
    String? phone,
    int? totalSaldo,
    bool? isLoggedIn,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      totalSaldo: totalSaldo ?? this.totalSaldo,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}