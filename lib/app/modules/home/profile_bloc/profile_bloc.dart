import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/shared/exceptions/app_exception.dart';
import 'package:task_manager/app/shared/models/profile.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepo authRepo;

  ProfileBloc(this.authRepo) : super(const ProfileState()) {
    on<ProfileEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future mapEventToState(ProfileEvent event, Emitter<ProfileState> emit) async {
    if (event is ProfileRequested) {
      try {
        Profile user = await authRepo.getCurrentUser();
        emit(ProfileState(profile: user));
      } on AppException catch (e) {
        emit(ProfileState(error: e.message));
      }
    }
  }
}
