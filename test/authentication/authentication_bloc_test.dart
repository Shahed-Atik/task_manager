import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/app/modules/app_bloc/app_bloc.dart';
import 'package:task_manager/app/modules/app_bloc/app_event.dart';
import 'package:task_manager/app/modules/app_bloc/app_state.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  User user = User.fromMap(const {
    "id": 1,
    "username": "emilys",
    "email": "emily.johnson@x.dummyjson.com",
    "firstName": "Emily",
    "lastName": "Johnson",
    "gender": "female",
    "image": "https://dummyjson.com/icon/emilys/128",
    "token":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMTc0MCwiZXhwIjoxNzE3NjE1MzQwfQ.eQnhQSnS4o0sXZWARh2HsWrEr6XfDT4ngh0ejiykfH8",
    "refreshToken":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJtaWNoYWVsdyIsImVtYWlsIjoibWljaGFlbC53aWxsaWFtc0B4LmR1bW15anNvbi5jb20iLCJmaXJzdE5hbWUiOiJNaWNoYWVsIiwibGFzdE5hbWUiOiJXaWxsaWFtcyIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL21pY2hhZWx3LzEyOCIsImlhdCI6MTcxNzYxMTc0MCwiZXhwIjoxNzIwMjAzNzQwfQ.YsStJdmdUjKOUlbXdqze0nEScCM_RJw9rnuy0RdSn88"
  });
  late AuthRepo authRepo;
  setUp(() {
    authRepo = _MockAuthRepo();
    when(
      () => authRepo.tokenStorageStatus,
    ).thenAnswer((_) => const Stream.empty());
  });

  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when user is not found',
      setUp: () {
        when(() => authRepo.tokenStorageStatus).thenAnswer(
          (_) => Stream.value(null),
        );
      },
      build: () => AppBloc(authRepo: authRepo),
      expect: () => const <AppState>[
        AppState.unauthenticated(),
      ],
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when user is found',
      setUp: () {
        when(() => authRepo.tokenStorageStatus).thenAnswer(
          (_) => Stream.value(user),
        );
        when(() => authRepo.getLocalUser()).thenAnswer(
          (_) => user,
        );
      },
      build: () => AppBloc(authRepo: authRepo),
      expect: () => <AppState>[
        AppState.authenticated(user),
      ],
    );
  });

  group('AppStatusChanged', () {
    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when status is authenticated but getUser return null',
      setUp: () {
        when(
          () => authRepo.tokenStorageStatus,
        ).thenAnswer((_) => Stream.value(user));
        when(() => authRepo.getLocalUser()).thenAnswer(
          (_) => null,
        );
      },
      build: () => AppBloc(authRepo: authRepo),
      expect: () => const <AppState>[
        AppState.unauthenticated(),
      ],
    );
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AppBloc, AppState>(
      'calls logOut on authRepo '
      'when AppLogoutRequested is added',
      build: () => AppBloc(authRepo: authRepo),
      act: (bloc) => bloc.add(const AppLogoutRequested()),
      verify: (_) {
        verify(() => authRepo.logOut()).called(1);
      },
    );
  });
}
