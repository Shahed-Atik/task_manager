import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/shared/exceptions/app_exception.dart';
import 'package:task_manager/app/shared/models/form_submission_status.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo authRepo;

  LoginBloc({required this.authRepo}) : super(const LoginState()) {
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    // Username updated
    if (event is LoginUsernameChanged) {
      emit(state.copyWith(username: event.username));

      // Password updated
    } else if (event is LoginPasswordChanged) {
      emit(state.copyWith(password: event.password));

      // Form submitted
    } else if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        //todo pass param
        User user = await authRepo.login();
        emit(state.copyWith(formStatus: SubmissionSuccess(user: user)));
      } on AppException catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e.message)));
      }
    }
  }
}
