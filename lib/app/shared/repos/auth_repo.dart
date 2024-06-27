import 'package:dio/dio.dart';
import 'package:task_manager/app/shared/exceptions/app_exception_handler.dart';
import 'package:task_manager/app/shared/http_client/refresh_token.dart';
import 'package:task_manager/app/shared/models/profile.dart';
import 'package:task_manager/app/shared/models/user.dart';

class AuthRepo {
  final Dio _dio;

  AuthRepo(this._dio);

  Future<User> login(
      {String username = 'emilys', String password = "emilyspass"}) async {
    try {
      Response response = await _dio.post('/auth/login', data: {
        "username": username,
        "password": password,
        "expiresInMins": 10, // optional, defaults to 60
      });
      User user = User.fromMap(response.data);
      return user;
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<Profile> getCurrentUser() async {
    try {
      Response response = await _dio.get("/auth/me");
      return Profile.fromMap(response.data);
    } catch (e) {
      throw AppExceptionHandler.handleError(e);
    }
  }

  Future<AppAuthToken> refreshToken(AppAuthToken token, Dio dio) async {
    Response response = await dio.post('/auth/refresh', data: {
      "refreshToken": token.refreshToken,
      "expiresInMins": 10, // optional, defaults to 60
    });

    Map<String, dynamic> param = (response.data as Map<String, dynamic>)
      ..addAll({
        "tokenType": "Bearer",
      });

    return AppAuthToken.fromMap(param);
  }
}
