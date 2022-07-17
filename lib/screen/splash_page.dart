import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tmdb_app/app/app_bloc.dart';
import 'package:tmdb_app/screen/home_page.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Navigate());
  }

  void Navigate(){
    Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomePage()));
  }


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AppBloc>(context);
    bloc.add(RunApp());
    return Scaffold(
                backgroundColor: const Color.fromARGB(255, 3, 37, 65),
                body:
                Center(
                  child: SvgPicture.asset('assets/logo.svg'),
                ));

  }

  @override
  void dispose() {
    super.dispose();
  }
}
