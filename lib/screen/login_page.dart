import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tmdb_app/app/app_bloc.dart';

import 'package:tmdb_app/auth/auth_repository.dart';
import 'package:tmdb_app/auth/form_submit_status.dart';
import 'package:tmdb_app/auth/login_bloc.dart';
import 'package:tmdb_app/auth/login_event.dart';
import 'package:tmdb_app/auth/login_state.dart';

import 'package:tmdb_app/src/local_auth.dart';

import 'package:tmdb_app/screen/home_page.dart';
import 'dart:ui';

import '../commons/widgets/app_bar/detail_bar.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late bool? _doLogin = false;
  late String? username = '';
  late AppBloc appBloc;
  late LoginBloc loginBloc;
  late AuthRepository authRepo;
  @override
  void initState() {

    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    authRepo = RepositoryProvider.of<AuthRepository>(context);
    loginBloc = LoginBloc(authRepo: authRepo);
    appBloc.add(GetUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        bloc: appBloc,
        builder: (context, state) {
            if(state is Logined){
              _doLogin = true;
              username = state.user?.username;
            }
            else if (state is Logouted){
              _doLogin = false;
            }
          return Scaffold(
              appBar: DetailAppBar(doLogin: _doLogin, username: username),

              body: BlocProvider(
                  create: (context) => loginBloc,
                  child: Center(
                    child: BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          var formStatus = state.formStatus;
                          if (formStatus is SubmissionFailed) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Wrong username or password"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Retry"))
                                    ],
                                  );
                                });
                          } else if (formStatus is SubmissionSuccess) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                          }
                        },
                        child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Login to your account",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 30),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: BlocBuilder<LoginBloc, LoginState>(
                                        builder: (context, state) {
                                      return TextFormField(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Username"),
                                        controller: usernameController,
                                        textInputAction: TextInputAction.next,
                                        validator: (value) =>
                                            state.isValidUsername
                                                ? null
                                                : 'Username shouldnot be empty',
                                        onChanged: (value) => context
                                            .read<LoginBloc>()
                                            .add(LoginUsernameChange(value)),
                                      );
                                    })),
                                const SizedBox(height: 20),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: BlocBuilder<LoginBloc, LoginState>(
                                        builder: (context, state) {
                                      return TextFormField(
                                        obscureText: true,
                                        obscuringCharacter: '*',
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Password"),
                                        validator: (value) =>
                                            state.isValidPassword
                                                ? null
                                                : 'Password shouldnot be empty',
                                        onChanged: (value) => context
                                            .read<LoginBloc>()
                                            .add(LoginPasswordChange(value)),
                                        controller: passwordController,
                                        textInputAction: TextInputAction.done,
                                      );
                                    })),
                                const SizedBox(height: 30),
                                BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                  return state.formStatus is FormSubmitting
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              loginBloc.add(LoginSubmitted(usernameController.text, passwordController.text));
                                            }
                                          },
                                          child: const Text("Login",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color.fromARGB(
                                                  255, 3, 37, 65)));
                                }),
                                const SizedBox(height: 30),
                                BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                  return ElevatedButton.icon(
                                      onPressed: () async {
                                        final isEnable = await LocalAuthApi.enable();
                                        if(!isEnable){
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "You do not enable your fingerprint authentication"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                        child:
                                                        const Text("OK")),
                                                  ],
                                                );
                                              });
                                        }
                                        else
                                          {final bool isAuthenticated =
                                            await LocalAuthApi.authenticate();
                                          if(isAuthenticated == true){
                                            loginBloc.add(LoginFingerPrint());  }
                                          }
                                      },
                                      icon: const Icon(Icons.fingerprint),
                                      label: const Text("Login by fingerprint"),
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 3, 37, 65)));
                                }),
                                const SizedBox(height: 30),
                                GestureDetector(
                                    onTap: () {},
                                    child: const Text("Reset password",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 1, 180, 228)))),
                              ],
                            )))),
                  )));
        });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
