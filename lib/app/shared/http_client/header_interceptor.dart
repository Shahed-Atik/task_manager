import 'package:dio/dio.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';

class HeaderInterceptor extends Interceptor {
  final LocalStorageService _localStorageService;

  HeaderInterceptor(this._localStorageService);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    User? user = _localStorageService.getUser();
    if (user != null) {
      options.headers.addAll({"Authorization": "Bearer ${user.accessToken}"});
    }

    handler.next(options);
  }
}
