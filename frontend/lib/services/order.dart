import 'package:stock_master/models/order.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  Dio api = Api.api();

  Future<Order> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('orders/', data: data);

    return Order.fromJson(response.data);
  }

  Future<Order> get(int id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('orders/$id');

    return Order.fromJson(response.data);
  }

  Future<List<Order>> getAll() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('orders/');

    return (response.data as List)
        .map((e) => Order.fromJson(e))
        .toList();
  }

  Future<Order> update(int id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.put('orders/$id', data: data);

    return Order.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    await api.delete('orders/$id');
  }
  
}
