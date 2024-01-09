import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ContatosCustomDio {
  final _dio = Dio();
  Dio get dio => _dio;

  ContatosCustomDio() {
    _dio.options.headers["X-Parse-Application-Id"] =
        dotenv.env['xParseApplicationId'];
    _dio.options.headers["X-Parse-REST-API-Key"] =
        dotenv.env['xParseRESTAPIKey'];
    _dio.options.headers["Content-Type"] = dotenv.env['contentType'];
    _dio.options.baseUrl = dotenv.env['baseUrl']!;
  }
}
