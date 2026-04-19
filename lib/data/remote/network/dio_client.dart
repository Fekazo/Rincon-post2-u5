import 'package:dio/dio.dart';

Dio buildDioClient() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Interceptor de autenticación simulada
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['X-App-Version'] = '1.0.0';
      options.headers['X-Platform'] = 'flutter';
      handler.next(options);
    },
    onError: (DioException e, handler) {
      print('[DioError] ${e.type}: ${e.message}');
      handler.next(e);
    },
  ));

  // Interceptor de logging (solo en debug)
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
  ));

  return dio;
}