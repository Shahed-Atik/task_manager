import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app/modules/app_bloc/app_bloc.dart';
import 'package:task_manager/app/modules/app_bloc/app_state.dart';
import 'package:task_manager/app/modules/home/home_page.dart';
import 'package:task_manager/app/shared/http_client/dio_client.dart';
import 'package:task_manager/app/shared/http_client/header_interceptor.dart';
import 'package:task_manager/app/shared/http_client/refresh_token.dart';
import 'package:task_manager/app/shared/repos/auth_repo.dart';
import 'app/modules/login/login_page.dart';
import '/app/shared/services/local_storage_service.dart';
import 'app/shared/repos/task_repo.dart';

GetIt getIt = GetIt.instance;
String baseUrl = "https://dummyjson.com";

void main() async {
  await preInitializations();
  runApp(const MyApp());
}

Future preInitializations() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<LocalStorageService>(
      LocalStorageService(getIt<SharedPreferences>()));

  getIt.registerSingleton<TokenStorageImpl>(
      TokenStorageImpl(getIt<LocalStorageService>()));

  getIt.registerSingleton<Dio>(
    DioClient.create(
      baseUrl: baseUrl,
      tokenStorageImpl: getIt<TokenStorageImpl>(),
      interceptors: [
        HeaderInterceptor(getIt<LocalStorageService>()),
      ],
    ),
  );

  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt<Dio>()));

  getIt.registerLazySingleton<TaskRepo>(
      () => TaskRepo(getIt<Dio>(), getIt<LocalStorageService>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(
        localStorageService: getIt.get(),
        tokenStorage: getIt.get(),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  width: 0,
                  color: Colors.transparent,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                )))),
        home: BlocBuilder<AppBloc, AppState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              switch (state.status) {
                case AppStatus.authenticated:
                  return const HomePage();
                case AppStatus.unauthenticated:
                  return const LoginPage();
              }
            }),
      ),
    );
  }
}
