import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/models/authenticated_user.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';

class UserService {
  Dio api = Api.api();

  Future<AuthenticatedUser> login(Map<String, dynamic> data) async {
    final response = await api.post('login', data: data);

    return AuthenticatedUser.fromJson(response.data);
  }

  Future<User> create(Map<String, dynamic> data) async {
    final response = await api.post('register', data: data);

    return User.fromJson(response.data);
  }

  Future<User> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('users/$id');

    return User.fromJson(response.data);
  }

  Future<User> update(int id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.put('users/$id', data: data);

    return User.fromJson(response.data);
  }

  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('password', data: data);

    return response.data;
  }
}
