import 'package:task_manager/app/shared/models/user.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

final class AppLoginRequested extends AppEvent {
  const AppLoginRequested(this.user);

  final User user;
}
