import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/api/api_client.dart';
import 'package:tmdb_app/auth/auth_repository.dart';


import 'package:tmdb_app/screen/splash_page.dart';

import 'package:tmdb_app/styles.dart';

import 'app/app_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late APIClient apiClient;
  late AuthRepository authRepo;
  late AppBloc appBloc;

  @override
  void initState() {
    super.initState();
    authRepo = AuthRepository();
    appBloc = AppBloc(authRepo, authRepo.client);

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => authRepo,
        child: BlocProvider<AppBloc>(
            create: (context) =>
                appBloc,
            child: MaterialApp(theme: DefaultAppStyles().themeData, title: 'Flutter Demo', home: SplashPage())));
  }
}

// Widget buildTrending (List<dynamic> list) {
//
// }
