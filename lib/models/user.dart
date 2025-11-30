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
}
