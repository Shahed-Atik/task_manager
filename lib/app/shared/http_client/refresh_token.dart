import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_refresh_bot/dio_refresh_bot.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';
import 'package:task_manager/main.dart';

class TokenStorageImpl extends BotMemoryTokenStorage<AppAuthToken> {
  final LocalStorageService _localStorageService;

  TokenStorageImpl(this._localStorageService);
  @override
  AppAuthToken? get initValue {
    User? user = _localStorageService.getUser();
    if (user != null) {
      return AppAuthToken(
        accessToken: user.token,
        refreshToken: user.refreshToken,
      );
    }
    return null;
  }

  @override
  FutureOr<void> delete([String? message]) async {
    _localStorageService.deleteUserData();
    await super.delete(message);
  }

  @override
  FutureOr<void> write(AppAuthToken? value) async {
    User? user = _localStorageService.getUser();
    if (value != null) {
      _localStorageService.setUser(
        user!.copyWith(
          refreshToken: value.refreshToken,
          token: value.accessToken,
        ),
      );
    }
    await super.write(value);
  }
}

Future<AppAuthToken> refreshTokenRequest(
    AppAuthToken token, Dio tokenDio) async {
  AuthRepo authRepo = getIt.get<AuthRepo>();
  return await authRepo.refreshToken(token, tokenDio);
}

class AppAuthToken extends AuthToken {
  const AppAuthToken({
    required super.accessToken,
    super.tokenType = 'Bearer',
    super.refreshToken,
  });

  factory AppAuthToken.fromMap(Map<String, dynamic> map) {
    return AppAuthToken(
      accessToken: map['token'] as String,
      tokenType: map['tokenType'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'tokenType': tokenType,
      'refreshToken': refreshToken,
    };
  }
}

TokenProtocol tokenProtocol = TokenProtocol(shouldRefresh: (
  Response? response,
  dynamic _,
) {
  return response?.statusCode == 401;
});
