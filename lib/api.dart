import 'package:dio/dio.dart';

class Api {

  static api() {
    final options = BaseOptions(
      baseUrl: 'http://172.20.10.4:3030/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    return Dio(options);
  }

}