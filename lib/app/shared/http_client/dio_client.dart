import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_refresh_bot/dio_refresh_bot.dart';
import 'package:flutter/foundation.dart';
import 'package:task_manager/app/shared/http_client/refresh_token.dart';

import '../models/user.dart';

class DioClient {
  static Dio create(
      {required String baseUrl,
      List<Interceptor>? interceptors,
      required TokenStorageImpl tokenStorageImpl}) {
    final baseOptions = BaseOptions(baseUrl: baseUrl);

    final dio = Dio(baseOptions);

    final refreshTokenInter = RefreshTokenInterceptor<User>(
        tokenDio: createRefreshToken(baseUrl: baseUrl),
        tokenProtocol: tokenProtocol,
        tokenStorage: tokenStorageImpl,
        debugLog: true,
        onRevoked: (error) {
          log("Refresh token failed");
          log(error.toString());
          return null;
        },
        refreshToken: (user, tokenDio) =>
            refreshTokenRequest(user, tokenDio));

    dio.interceptors.add(refreshTokenInter);

    if (interceptors != null) dio.interceptors.addAll(interceptors);
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
          requestBody: true, responseBody: true, responseHeader: false));
    }
    return dio;
  }

  static Dio createRefreshToken({required String baseUrl}) {
    final baseOptions = BaseOptions(baseUrl: baseUrl);
    final dio = Dio(baseOptions);
    dio.interceptors.addAll([
      LogInterceptor(
          requestBody: true, responseBody: true, request: true, error: true),
    ]);
    return dio;
  }
}
