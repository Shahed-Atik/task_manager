import 'package:task_manager/app/shared/models/profile.dart';

class ProfileState {
  const ProfileState({this.profile, this.error});

  final Profile? profile;
  final String? error;
}
