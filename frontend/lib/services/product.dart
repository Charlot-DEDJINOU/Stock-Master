import 'package:stock_master/models/product.dart';
import 'package:stock_master/api.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  Dio api = Api.api();

  Future<Product> create(Map<String, dynamic> data) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      }

      final response = await api.post('products/', data: data);

      return Product.fromJson(response.data);
    } catch (error) {
      handleApiError(error);
      rethrow;
    }
    
  }

  Future<Product> get(int id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      }

      final response = await api.get('products/$id');

      return Product.fromJson(response.data);
    } catch (error) {
      handleApiError(error);
      rethrow;
    }
  }

  Future<List<Product>> getAll() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      }

      final response = await api.get('products/');
      return (response.data as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (error) {
      handleApiError(error);
      rethrow;
    }
  }

  Future<Product> update(int id, Map<String, dynamic> data) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      }

      final response = await api.put('products/$id', data: data);

      return Product.fromJson(response.data);
    } catch (error) {
      handleApiError(error);
      rethrow;
    }

  }

  Future<void> delete(int id) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      }

      await api.delete('products/$id');
    } catch (error) {
      handleApiError(error);
      rethrow;
    }
  }

  void handleApiError(error) async {
    if (error is DioError) {
      if (error.response != null) {
        switch (error.response!.statusCode) {
          case 401:
            // Gérer l'erreur 401 (Non autorisé)
            print("Erreur 401: ${error.response!.data}");
            break;
          case 404:
            // Gérer l'erreur 404 (Non trouvé)
            print("Erreur 404: ${error.response!.data}");
            break;
          case 500:
            // Gérer l'erreur 500 (Erreur interne du serveur)
            print("Erreur 500: ${error.response!.data}");
            break;
          default:
            // Gérer d'autres codes d'erreur HTTP ici
            print("Erreur HTTP non gérée: ${error.response!.data}");
        }
      } else {
        // Gérer une erreur de connexion réseau
        print("Erreur de connexion: $error");
      }
    } else {
      // Gérer d'autres types d'erreurs ici
      print("Erreur inattendue: $error");
    }
  }

}
