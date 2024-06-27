import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/app/modules/app_bloc/app_bloc.dart';
import 'package:task_manager/app/modules/app_bloc/app_event.dart';
import 'package:task_manager/app/modules/app_bloc/app_state.dart';
import 'package:task_manager/app/shared/http_client/refresh_token.dart';
import 'package:task_manager/app/shared/models/user.dart';
import 'package:task_manager/app/shared/services/local_storage_service.dart';

class _MockLocalStorageService extends Mock implements LocalStorageService {}

class _MockTokenStorageImpl extends Mock implements TokenStorageImpl {}

void main() {
  User user = User.fromMap({
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
  late LocalStorageService localStorageService;
  late TokenStorageImpl tokenStorageImpl;
  setUp(() {
    localStorageService = _MockLocalStorageService();
    tokenStorageImpl = _MockTokenStorageImpl();
    when(
      tokenStorageImpl.stream,
    ).thenAnswer((_) => const Stream.empty());
  });

  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when user is not found',
      setUp: () {
        when(localStorageService.getUser()).thenAnswer(
          (_) => null,
        );
      },
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      expect: () => const <AppState>[
        AppState.unauthenticated(),
      ],
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when user is found',
      setUp: () {
        when(localStorageService.getUser()).thenAnswer((_) => user);
      },
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      expect: () => <AppState>[
        AppState.authenticated(user),
      ],
    );

    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when the user is deleted',
      setUp: () {
        when(
          tokenStorageImpl.stream,
        ).thenAnswer((_) => Stream.value(null));
        when(
          localStorageService.getUser(),
        ).thenAnswer((_) => null);
      },
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      expect: () => <AppState>[
        const AppState.unauthenticated(),
      ],
    );
  });

  group('AppLoginRequested', () {
    blocTest<AppBloc, AppState>(
      'calls setUser on localStorageService '
      'when AppLoginRequested is added',
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      act: (bloc) => bloc.add(AppLoginRequested(user)),
      verify: (_) {
        verify(() => localStorageService.setUser(user)).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when save User success',
      setUp: () {
        when(localStorageService.setUser(user)).thenAnswer((_) async => true);
      },
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      expect: () => <AppState>[
        AppState.authenticated(user),
      ],
    );
    blocTest<AppBloc, AppState>(
      'emits [unauthenticated] when save User does not success',
      setUp: () {
        when(localStorageService.setUser(user)).thenAnswer((_) async => false);
      },
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      expect: () => <AppState>[
        const AppState.unauthenticated(),
      ],
    );
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AppBloc, AppState>(
      'calls deleteUserData on localStorageService '
      'when AppLogoutRequested is added',
      build: () => AppBloc(
          localStorageService: localStorageService,
          tokenStorage: tokenStorageImpl),
      act: (bloc) => bloc.add(const AppLogoutRequested()),
      verify: (_) {
        verify(() => localStorageService.deleteUserData()).called(1);
      },
    );
  });
}
