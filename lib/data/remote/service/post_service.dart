import 'package:dio/dio.dart';
import '../dto/post_dto.dart';

// Errores de dominio tipados
sealed class AppError {
  const AppError();
}

class NetworkError extends AppError {
  const NetworkError();
}

class UnauthorizedError extends AppError {
  const UnauthorizedError();
}

class NotFoundError extends AppError {
  const NotFoundError(this.resource);
  final String resource;
}

class ServerError extends AppError {
  const ServerError(this.code);
  final int code;
}

class UnknownError extends AppError {
  const UnknownError(this.message);
  final String message;
}

// Mapper de DioException a AppError
AppError mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkError();
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      return switch (code) {
        401 || 403 => const UnauthorizedError(),
        404 => const NotFoundError("Post"),
        _ when (code != null && code >= 500) => ServerError(code),
        _ => UnknownError(e.message ?? "Error desconocido"),
      };
    default:
      return UnknownError(e.message ?? "Error desconocido");
  }
}

// Servicio de posts
class PostService {
  final Dio _dio;

  PostService(this._dio);

  Future<List<PostDto>> fetchPosts({int page = 1, int limit = 15}) async {
    final response = await _dio.get(
      '/posts',
      queryParameters: {'_page': page, '_limit': limit},
    );
    final List<dynamic> data = response.data as List;
    return data
        .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}