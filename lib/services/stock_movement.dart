import 'package:stock_master/models/stock_movement.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockmovementServive {
  Dio api = Api.api();

  Future<StockMovement> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('stock_movements', data: data);

    return StockMovement.fromJson(response.data);
  }

  Future<StockMovement> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('stock_movements/$id');

    return StockMovement.fromJson(response.data);
  }

  Future<List<StockMovement>> getAll() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('stock_movements');

    return (response.data as List)
        .map((e) => StockMovement.fromJson(e))
        .toList();
  }

  Future<StockMovement> update(String id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.put('stock_movements/$id', data: data);

    return StockMovement.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    await api.delete('stock_movements/$id');
  }
  
}
