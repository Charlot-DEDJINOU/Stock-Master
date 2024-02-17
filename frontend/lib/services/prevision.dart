import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/api.dart';
import 'package:stock_master/models/prevision.dart';


class PrevisionService {
  Dio api = Api.api();

  Future<List<Prevision>> getPrevisions() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token.isNotEmpty) {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('previsions/');

    return (response.data as List)
        .map((e) => Prevision.fromJson(e))
        .toList();
  }
}
