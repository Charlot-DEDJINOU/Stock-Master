import 'package:stock_master/models/category.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  Dio api = Api.api();

  Future<Category> create(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.post('category', data: data);

    return Category.fromJson(response.data);
  }

  Future<Category> get(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('category/$id');

    return Category.fromJson(response.data);
  }

  Future<List<Category>> getAll() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('categorys');

    return (response.data['data'] as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  Future<Category> update(String id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.put('category/$id', data: data);

    return Category.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    await api.delete('category/$id');
  }
}
