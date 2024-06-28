import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const AppState.init()) {
    on<AppStatusChanged>(_onAppStatusChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _storageStatusSubscription = authRepo.tokenStorageStatus.listen(
      (event) {
        add(AppStatusChanged(event != null
            ? AppStatus.authenticated
            : AppStatus.unauthenticated));
      },
    );

    add(const AppStatusChanged(AppStatus.authenticated));
  }

  final AuthRepo _authRepo;

  late StreamSubscription<User?> _storageStatusSubscription;

  Future<void> _onAppStatusChanged(
    AppStatusChanged event,
    Emitter<AppState> emit,
  ) async {
    switch (event.status) {
      case AppStatus.unauthenticated:
        return emit(const AppState.unauthenticated());
      case AppStatus.authenticated:
        final user = _tryGetUser();
        return emit(
          user != null
              ? AppState.authenticated(user)
              : const AppState.unauthenticated(),
        );
      case AppStatus.initial:
        return emit(const AppState.init());
    }
  }

  User? _tryGetUser() {
    final user = _authRepo.getLocalUser();
    return user;
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    _authRepo.logOut();
  }

  @override
  Future<void> close() {
    _storageStatusSubscription.cancel();
    return super.close();
  }
}
