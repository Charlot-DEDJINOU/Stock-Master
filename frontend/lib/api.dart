import 'package:dio/dio.dart';

class Api {

  static api() {
    final options = BaseOptions(
      baseUrl: 'https://stock-kxjz.onrender.com/',
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      followRedirects: true,
    );

    return Dio(options);
  }

}