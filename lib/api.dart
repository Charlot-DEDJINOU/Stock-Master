import 'package:dio/dio.dart';

class Api {

  static api() {
    final options = BaseOptions(
      baseUrl: 'http://192.168.84.64:8000/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    return Dio(options);
  }

}