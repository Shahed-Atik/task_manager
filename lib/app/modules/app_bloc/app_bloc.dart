import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/shared/http_client/refresh_token.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(
      {required LocalStorageService localStorageService,
      required TokenStorageImpl tokenStorage})
      : _localStorageService = localStorageService,
        super(
          localStorageService.getUser() != null
              ? AppState.authenticated(localStorageService.getUser()!)
              : const AppState.unauthenticated(),
        ) {
    on<AppLoginRequested>(_onLoginRequested);
    on<AppLogoutRequested>(_onLogoutRequested);
    _authenticationStatusSubscription = tokenStorage.stream.listen(
      (event) {
        if (event == null) add(const AppLogoutRequested());
      },
    );
  }

  final LocalStorageService _localStorageService;
  late StreamSubscription<AppAuthToken?> _authenticationStatusSubscription;
  void _onLoginRequested(
      AppLoginRequested event, Emitter<AppState> emit) async {
    await _localStorageService.setUser(event.user).then((result) {
      if (result) {
        emit(AppState.authenticated(event.user));
      } else {
        emit(const AppState.unauthenticated());
      }
    });
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    await _localStorageService.deleteUserData().then((result) {
      if (result) emit(const AppState.unauthenticated());
    });
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }
}
