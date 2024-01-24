import 'dart:convert';

AuthenticatedUser authenticatedUserFromJson(String str) => AuthenticatedUser.fromJson(json.decode(str));

String authenticatedUserToJson(AuthenticatedUser data) => json.encode(data.toJson());

class AuthenticatedUser {
  String? accessToken;
  Authentication? authentication;
  User? user;

  AuthenticatedUser({
    this.accessToken,
    this.authentication,
    this.user,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) => AuthenticatedUser(
    accessToken: json["accessToken"],
    authentication: json["authentication"] == null ? null : Authentication.fromJson(json["authentication"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "authentication": authentication?.toJson(),
    "user": user?.toJson(),
  };
}

class Authentication {
  String? strategy;
  Payload? payload;

  Authentication({
    this.strategy,
    this.payload,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
    strategy: json["strategy"],
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "strategy": strategy,
    "payload": payload?.toJson(),
  };
}

class Payload {
  int? iat;
  int? exp;
  String? aud;
  String? sub;
  String? jti;

  Payload({
    this.iat,
    this.exp,
    this.aud,
    this.sub,
    this.jti,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    iat: json["iat"],
    exp: json["exp"],
    aud: json["aud"],
    sub: json["sub"],
    jti: json["jti"],
  );

  Map<String, dynamic> toJson() => {
    "iat": iat,
    "exp": exp,
    "aud": aud,
    "sub": sub,
    "jti": jti,
  };
}
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
