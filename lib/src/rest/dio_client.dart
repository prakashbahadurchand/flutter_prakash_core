import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../core/errors/exceptions.dart';

abstract interface class IAuthTokenStrategy {
  Future<String?> getAccessToken();
  Future<bool> refreshTokens();
  Future<void> onAuthenticationFailed();
}

class RestConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, String>? defaultHeaders;
  final IAuthTokenStrategy? authTokenStrategy;

  const RestConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.defaultHeaders,
    this.authTokenStrategy,
  });
}

class DioClient {
  final RestConfig config;
  final Dio dio;

  DioClient({required this.config})
    : dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
          headers: config.defaultHeaders,
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final hasConnection = await InternetConnection().hasInternetAccess;
          if (!hasConnection) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: const NetworkException('No internet connection'),
              ),
            );
          }

          if (config.authTokenStrategy != null) {
            final token = await config.authTokenStrategy!.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              config.authTokenStrategy != null) {
            final refreshed = await config.authTokenStrategy!.refreshTokens();
            if (refreshed) {
              final token = await config.authTokenStrategy!.getAccessToken();
              e.requestOptions.headers['Authorization'] = 'Bearer $token';
              try {
                final response = await dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } catch (_) {
                await config.authTokenStrategy!.onAuthenticationFailed();
              }
            } else {
              await config.authTokenStrategy!.onAuthenticationFailed();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
