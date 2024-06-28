import 'package:dio/dio.dart';
import 'package:task_manager/app/shared/exceptions/app_exception_handler.dart';
import 'package:task_manager/app/shared/http_client/refresh_token.dart';
import 'package:task_manager/app/shared/models/profile.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';

class AuthRepo {
  final Dio _dio;
  final TokenStorageImpl _tokenStorage;
  final LocalStorageService _localStorageService;

  AuthRepo(this._dio, this._tokenStorage, this._localStorageService);

  Stream<User?> get tokenStorageStatus async* {
    yield* _tokenStorage.stream;
  }

  Future<User> login(
      {String username = 'emilys', String password = "emilyspass"}) async {
    try {
      Response response = await _dio.post('/auth/login', data: {
        "username": username,
        "password": password,
        "expiresInMins": 10, // optional, defaults to 60
      });
      User user = User.fromMap(response.data);
      _tokenStorage.write(user);
      return user;
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  void logOut() {
    _tokenStorage.delete();
  }

  Future<Profile> getCurrentUser() async {
    try {
      Response response = await _dio.get("/auth/me");
      return Profile.fromMap(response.data);
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<User> refreshToken(User user, Dio dio) async {
    Response response = await dio.post('/auth/refresh', data: {
      "refreshToken": user.refreshToken,
      "expiresInMins": 10, // optional, defaults to 60
    });

    Map<String, dynamic> param = (response.data as Map<String, dynamic>);

    User newUser = user.copyWith(
        accessToken: param["token"], refreshToken: param["refreshToken"]);
    _tokenStorage.write(newUser);
    return newUser;
  }

  User? getLocalUser() {
    final user = _localStorageService.getUser();
    return user;
  }
}
