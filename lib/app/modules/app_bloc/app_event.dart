import 'package:task_manager/app/modules/app_bloc/app_state.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppStatusChanged extends AppEvent {
  const AppStatusChanged(this.status);

  final AppStatus status;
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}
