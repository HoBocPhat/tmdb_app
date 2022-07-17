import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/auth/auth_repository.dart';
import 'package:tmdb_app/setting/setting_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool _fingerprint = true;
  // Future<bool?> getBiometric() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _fingerprint = prefs.getBool(SHARED_FINGERPRINT)!;
  //   return prefs.getBool(SHARED_FINGERPRINT);
  // }

  // Future changeBiometric(bool fingerprint) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool(SHARED_FINGERPRINT, fingerprint);
  // }

  @override
  void initState() {
    super.initState();
    //getBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 3, 37, 65),
          title: const Text('Settings'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
              create: (context) => SettingBloc(
                    authRepo: RepositoryProvider.of<AuthRepository>(context),
                  ),
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  const Text("Security", style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 20),
                  BlocListener<SettingBloc, SettingState>(
                      listener: (context, state) {

                    if (state is EnableFingerPrint) {
                      _fingerprint = true;
                    } else if (state is DisableFingerPrint) {
                      _fingerprint = false;
                    }
                  }, child: BlocBuilder<SettingBloc, SettingState>(
                          builder: (context, state) {
                            context
                                .read<SettingBloc>()
                                .add(GetBiometric());
                    return SwitchListTile(
                        value: _fingerprint,
                        title: const Text("Fingerprint Setting"),
                        onChanged: (bool value) {
                           context
                               .read<SettingBloc>()
                               .add(ChangeFingerprint(value));
                           setState(() {
                             _fingerprint = value;
                           });
                        },
                        secondary: const Icon(Icons.fingerprint));
                  }))
                ],
              )),
        ));
  }
}
