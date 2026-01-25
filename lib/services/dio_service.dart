import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scorelivepro/config/storage/secure_storage_helper.dart';

enum Methods { post, get, put, patch, delete }

// Simple Either implementation
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool isLeft;

  Either._(this._left, this._right, this.isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R value) => Either._(null, value, false);

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (isLeft) {
      return onLeft(_left as L);
    } else {
      return onRight(_right as R);
    }
  }
}

// Helper functions
Either<L, R> left<L, R>(L value) => Either.left(value);
Either<L, R> right<L, R>(R value) => Either.right(value);

typedef E<T> = Future<Either<String, T>>;

// 🔥 Top-level isolate-safe JSON processor
dynamic _processJsonInIsolate(dynamic data) {
  return jsonDecode(jsonEncode(data)); // deep parse + isolate safe
}

class DioManager {
  static final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static String? _cachedAccessToken;
  static DateTime? _tokenGeneratedAt;
  static Future<String?>? _refreshLock;
  // 🔹 Public method to reset cached token
  static void clearCachedToken() {
    _cachedAccessToken = null;
    _tokenGeneratedAt = null;
    _refreshLock = null;
  }

  static Future<void> logout() async {
    await SecureStorageHelper.clearAll();
    _cachedAccessToken = null;
    _tokenGeneratedAt = null;
    _refreshLock = null;
  }

  static void init() {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipAuth = options.extra['skipAuth'] == true;

          if (!skipAuth) {
            final token = await _getValidAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              log(
                '✅ Added Bearer token to request: ${options.uri}',
                name: 'TOKEN',
              );
            } else {
              log(
                '⚠️ No access token available, proceeding without auth: ${options.uri}',
                name: 'TOKEN',
              );
            }
          }

          // Log full request details
          final queryParams = options.queryParameters.isNotEmpty
              ? '?${Uri(queryParameters: options.queryParameters).query}'
              : '';
          log(
            '➡️ [${options.method}] ${options.uri}$queryParams',
            name: "API REQUEST",
          );

          // Log headers (excluding sensitive token)
          final headers = Map<String, dynamic>.from(options.headers);
          if (headers.containsKey('Authorization')) {
            headers['Authorization'] = 'Bearer ***';
          }
          log('📋 Headers: ${jsonEncode(headers)}', name: "API REQUEST");

          if (options.data != null) {
            if (options.data is FormData) {
              log(
                '📦 Sending FormData with ${options.data.fields.length} fields and ${options.data.files.length} files',
                name: "BODY",
              );
            } else {
              log('📤 Request Body: ${jsonEncode(options.data)}', name: "BODY");
            }
          } else if (options.queryParameters.isNotEmpty) {
            log(
              '📤 Query Params: ${jsonEncode(options.queryParameters)}',
              name: "BODY",
            );
          }

          handler.next(options);
        },
        onResponse: (response, handler) async {
          final respStr = jsonEncode(response.data);

          // Log response for debugging
          log(
            '✅ [${response.statusCode}] ${response.requestOptions.uri}',
            name: "API RESPONSE",
          );
          log('📥 Response Body: $respStr', name: "RESPONSE BODY");

          // Also print to console for easy viewing
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('✅ API SUCCESS [${response.statusCode}]');
          print('URL: ${response.requestOptions.uri}');
          print('Response: $respStr');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          handler.next(response);
        },
        onError: (DioException e, handler) async {
          final status = e.response?.statusCode;
          log('❌ [$status] ${e.requestOptions.uri}', name: "API ERROR");
          log(e.message ?? 'Unknown error', name: "ERROR MESSAGE");

          // Print detailed error to console
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          print('❌ API ERROR [${status ?? "NO STATUS"}]');
          print('URL: ${e.requestOptions.uri}');
          print('Method: ${e.requestOptions.method}');
          if (e.requestOptions.data != null) {
            print('Request Body: ${jsonEncode(e.requestOptions.data)}');
          }
          if (e.response != null) {
            print('Response: ${jsonEncode(e.response?.data)}');
          }
          print('Error: ${e.message}');
          print('Type: ${e.type}');
          print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          if (status == 401 && e.requestOptions.extra['retry'] != true) {
            final newToken = await _refreshAccessToken();
            if (newToken != null) {
              final opts = e.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              opts.extra['retry'] = true;

              try {
                final retryResponse = await _dio.fetch(opts);
                log('🔁 Retried request succeeded', name: "RETRY");
                return handler.resolve(retryResponse);
              } catch (err) {
                log('❌ Retry failed: $err', name: "RETRY");
              }
            } else {
              log('❌ Token refresh failed, clearing storage', name: "TOKEN");
              await SecureStorageHelper.clearAll();
              _cachedAccessToken = null;
              _tokenGeneratedAt = null;
            }
          }

          handler.next(e);
        },
      ),
    );
  }

  static Future<String?> _getValidAccessToken() async {
    final now = DateTime.now();
    // First check cache
    if (_cachedAccessToken != null &&
        _tokenGeneratedAt != null &&
        now.difference(_tokenGeneratedAt!).inMinutes < 5) {
      log('🟢 Using cached access token', name: 'TOKEN');
      return _cachedAccessToken;
    }

    // If not in cache, try to get from secure storage
    final storedToken = await SecureStorageHelper.getAccessToken();
    if (storedToken != null && storedToken.isNotEmpty) {
      log('🟢 Using stored access token', name: 'TOKEN');
      _cachedAccessToken = storedToken;
      _tokenGeneratedAt = now;
      return storedToken;
    }

    // If no stored token, try to refresh
    return await _refreshAccessToken();
  }

  // static Future<String?> _refreshAccessToken() async {
  //   if (_refreshLock != null) return _refreshLock;

  //   final completer = Completer<String?>();
  //   _refreshLock = completer.future;

  //   final refreshToken = await SecureStorageHelper.getRefreshToken();
  //   if (refreshToken == null || refreshToken.isEmpty) {
  //     _refreshLock = null;
  //     completer.complete(null);
  //     return null;
  //   }

  //   try {
  //     log('🔄 Generating new access token...', name: 'TOKEN');
  //     final response = await _dio.post(
  //       ApiEndPoint.refreshTokenUrl,
  //       data: {'refresh': refreshToken},
  //       options: Options(extra: {'skipAuth': true}),
  //     );

  //     final parsed = await compute(_processJsonInIsolate, response.data);
  //     final newAccess = parsed['access'];

  //     if (newAccess is String && newAccess.isNotEmpty) {
  //       _cachedAccessToken = newAccess;
  //       _tokenGeneratedAt = DateTime.now();
  //       log('✅ Token refreshed successfully', name: 'TOKEN');
  //       // 🔥🔥 Update token in SocketService

  //       completer.complete(newAccess);
  //       _refreshLock = null;
  //       return newAccess;
  //     }

  //     log('❌ Invalid refresh response', name: 'TOKEN');
  //     completer.complete(null);
  //     _refreshLock = null;
  //     return null;
  //   } catch (e) {
  //     log('❌ Token refresh failed: $e', name: 'TOKEN');
  //     completer.complete(null);
  //     _refreshLock = null;
  //     return null;
  //   }
  // }

  static Future<String?> _refreshAccessToken() async {
    if (_refreshLock != null) return _refreshLock;

    final completer = Completer<String?>();
    _refreshLock = completer.future;

    final refreshToken = await SecureStorageHelper.getRefreshToken();

    // ✅ Refresh token নেই → logout required message
    if (refreshToken == null || refreshToken.isEmpty) {
      _cachedAccessToken = null;
      _tokenGeneratedAt = null;
      _refreshLock = null;
      completer.completeError(
        "Session expired. Please login again.",
        StackTrace.current,
      );
      return null;
    }

//Generating new access token
    //   try {
    //     log('🔄 Generating new access token...', name: 'TOKEN');

    //     final response = await _dio.post(
    //       ApiEndPoint.refreshToken,
    //       data: {'refresh': refreshToken},
    //       options: Options(extra: {'skipAuth': true}),
    //     );

    //     final parsed = await compute(_processJsonInIsolate, response.data);
    //     final newAccess = parsed['access'];

    //     if (newAccess is String && newAccess.isNotEmpty) {
    //       _cachedAccessToken = newAccess;
    //       _tokenGeneratedAt = DateTime.now();
    //       log('✅ Token refreshed successfully', name: 'TOKEN');
    //       completer.complete(newAccess);
    //       _refreshLock = null;
    //       return newAccess;
    //     }

    //     log('❌ Invalid refresh response', name: 'TOKEN');
    //     _refreshLock = null;
    //     completer.completeError(
    //       "Session expired. Please login again.",
    //       StackTrace.current,
    //     );
    //     return null;
    //   } catch (e) {
    //     log('❌ Token refresh failed: $e', name: 'TOKEN');
    //     _refreshLock = null;
    //     completer.completeError(
    //       "Session expired. Please login again.",
    //       StackTrace.current,
    //     );
    //     return null;
    //   }
  }

  static E apiRequest({
    required String url,
    required Methods methods,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
    int successCode = 200,
    List<int>? altCodes,
  }) async {
    try {
      Response response;
      final options = Options(extra: {'skipAuth': skipAuth});

      switch (methods) {
        case Methods.get:
          response = await _dio.get(
            url,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case Methods.post:
          response = await _dio.post(url, data: body, options: options);
          break;
        case Methods.put:
          response = await _dio.put(url, data: body, options: options);
          break;
        case Methods.patch:
          response = await _dio.patch(url, data: body, options: options);
          break;
        case Methods.delete:
          response = await _dio.delete(url, data: body, options: options);
          break;
      }

      final validCodes = [successCode, ...?altCodes];
      if (validCodes.contains(response.statusCode)) {
        final parsed = await compute(_processJsonInIsolate, response.data);
        return right(parsed);
      } else {
        // ✅ Print error if status is 400
        if (response.statusCode == 400) {
          log(
            "❌ Bad Request (400) for $url: ${_extractFriendlyError(response)}",
            name: "API ERROR",
          );
        }
        return left(_extractFriendlyError(response));
      }
    } on DioException catch (e) {
      // Optionally print Dio errors
      if (e.response?.statusCode == 400) {
        print("api resonse dio error${e.response}");
        log(
          "❌ Dio 400 Error for ${e.requestOptions.uri}: ${_friendlyDioError(e)}",
          name: "API ERROR",
        );
      }
      return left(_friendlyDioError(e));
    } catch (e, stack) {
      log('⚠️ Unexpected error: $e', stackTrace: stack);
      return left("Unexpected error occurred. Please try again.");
    }
  }

  static E multipartRequest({
    required String url,
    required Map<String, dynamic> fields,
    String? filePath,
    String fileFieldName = 'file',
    bool skipAuth = false,
    int successCode = 200,
    Methods method = Methods.post,
  }) async {
    try {
      final formData = FormData();

      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      if (filePath != null &&
          filePath.isNotEmpty &&
          File(filePath).existsSync()) {
        formData.files.add(
          MapEntry(
            fileFieldName,
            await MultipartFile.fromFile(
              filePath,
              filename: filePath.split('/').last,
            ),
          ),
        );
        log('📸 Attached file: $filePath');
      }

      final options = Options(extra: {'skipAuth': skipAuth});
      Response response;

      switch (method) {
        case Methods.post:
          response = await _dio.post(url, data: formData, options: options);
          break;
        case Methods.patch:
          response = await _dio.patch(url, data: formData, options: options);
          break;
        case Methods.put:
          response = await _dio.put(url, data: formData, options: options);
          break;
        default:
          response = await _dio.post(url, data: formData, options: options);
      }

      if (response.statusCode == successCode || response.statusCode == 200) {
        final parsed = await compute(_processJsonInIsolate, response.data);
        log('✅ [${response.statusCode}] $url', name: "UPLOAD SUCCESS");
        log(jsonEncode(parsed), name: "UPLOAD RESPONSE");
        return right(parsed);
      } else {
        return left(_extractFriendlyError(response));
      }
    } on DioException catch (e) {
      return left(_friendlyDioError(e));
    } catch (e) {
      return left("Unexpected error. Please try again.");
    }
  }

  static String _extractFriendlyError(Response response) {
    final status = response.statusCode ?? 0;
    final data = response.data;

    if (status >= 500) return "Server error. Please try again later.";
    if (status >= 400) {
      // Handle 404 specifically
      if (status == 404) {
        return "Something went wrong. Try again later.";
      }

      if (data is Map<String, dynamic>) {
        // Try multiple common error message fields
        String? msg = data['error'] ??
            data['detail'] ??
            data['message'] ??
            data['msg'] ??
            data['error_message'];

        // If no direct message, check for nested error objects
        if (msg == null && data.containsKey('error')) {
          final errorObj = data['error'];
          if (errorObj is Map<String, dynamic>) {
            msg =
                errorObj['message'] ?? errorObj['detail'] ?? errorObj['error'];
          }
        }

        // Check for field-specific errors (common in validation errors)
        if (msg == null && data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map<String, dynamic>) {
            // Get first error message from validation errors
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              msg = firstError.first.toString();
            } else if (firstError is String) {
              msg = firstError;
            }
          } else if (errors is List && errors.isNotEmpty) {
            msg = errors.first.toString();
          }
        }

        // Check for non_field_errors (common in Django REST framework)
        if (msg == null && data.containsKey('non_field_errors')) {
          final nonFieldErrors = data['non_field_errors'];
          if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
            msg = nonFieldErrors.first.toString();
          }
        }

        return msg?.toString() ?? "This email is already registered $status.";
      }
      if (data is String) return data;
      return "Request failed with status $status.";
    }
    return "Unexpected server response ($status).";
  }

  static String _friendlyDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Connection timeout. Please try again.";
    }
    if (e.type == DioExceptionType.badResponse && e.response != null) {
      return _extractFriendlyError(e.response!);
    }
    if (e.error is SocketException) {
      return "No internet connection. Please check your network.";
    }
    return e.message ?? "Something went wrong. Please try again.";
  }
}
