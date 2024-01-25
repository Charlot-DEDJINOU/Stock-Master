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
    accessToken: json["access_token"],
    authentication: json["authentication"] == null ? null : Authentication.fromJson(json["authentication"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
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
  String fullname;
  String password;
  String email;

  User({
    required this.userId,
    required this.fullname,
    required this.password,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      fullname: json['full_name'],
      password: json['password'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullname,
      'password': password,
      'email': email,
    };
  }
  
}
