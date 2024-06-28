import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_refresh_bot/dio_refresh_bot.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';
import 'package:task_manager/main.dart';

class TokenStorageImpl extends BotMemoryTokenStorage<User> {
  final LocalStorageService _localStorageService;

  TokenStorageImpl(this._localStorageService);
  @override
  User? get initValue {
    User? user = _localStorageService.getUser();
    return user;
  }

  @override
  FutureOr<void> delete([String? message]) async {
    _localStorageService.deleteUserData();
    await super.delete(message);
  }

  @override
  FutureOr<void> write(User? value) async {
    if (value != null) {
      await _localStorageService.setUser(value);
    }
    await super.write(value);
  }
}

Future<User> refreshTokenRequest(User token, Dio tokenDio) async {
  AuthRepo authRepo = getIt.get<AuthRepo>();
  return await authRepo.refreshToken(token, tokenDio);
}

TokenProtocol tokenProtocol = TokenProtocol(shouldRefresh: (
  Response? response,
  dynamic _,
) {
  return response?.statusCode == 401;
});
