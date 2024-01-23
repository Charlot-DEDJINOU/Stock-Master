class User {
  int userId;
  String username;
  String password;
  String fullName;
  String email;
  String role;

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      password: json['password'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'password': password,
      'full_name': fullName,
      'email': email,
      'role': role,
    };
  }
  
}
