import 'package:stock_master/models/supplier.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierServive {
  Dio api = Api.api();

  Future<Supplier> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('suppliers', data: data);

    return Supplier.fromJson(response.data);
  }

  Future<Supplier> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('suppliers/$id');

    return Supplier.fromJson(response.data);
  }

  Future<List<Supplier>> getAll() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('suppliers');

    return (response.data as List)
        .map((e) => Supplier.fromJson(e))
        .toList();
  }

  Future<Supplier> update(String id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.put('suppliers/$id', data: data);

    return Supplier.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    await api.delete('suppliers/$id');
  }
  
}
