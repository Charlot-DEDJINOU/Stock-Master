import 'package:stock_master/models/authenticated_user.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';

class UserService {

  Dio api = Api.api();

  Future<AuthenticatedUser> login (Map<String, dynamic> data) async{
    final response = await api.post('authentication', data: data);

    return AuthenticatedUser.fromJson(response.data);
  }

  Future<User> create (Map<String, dynamic> data) async{
    final response = await api.post('users', data: data);

    return User.fromJson(response.data);
  }

}