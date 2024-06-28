import 'package:equatable/equatable.dart';
import 'package:task_manager/app/shared/models/user.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  initial,
}

final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.init() : this._(status: AppStatus.initial);

  final AppStatus status;
  final User? user;

  @override
  List<Object> get props => [status];
}
