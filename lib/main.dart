import 'package:dio/dio.dart';
import 'package:dio_refresh_bot/dio_refresh_bot.dart';
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

  getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepo(getIt<Dio>(), getIt<LocalStorageService>()));

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    AuthRepo authRepo = getIt.get<AuthRepo>();
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
