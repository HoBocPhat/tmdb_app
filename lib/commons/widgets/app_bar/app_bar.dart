

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:side_sheet/side_sheet.dart';
import '../../../app/app_bloc.dart';
import '../../../screen/home_page.dart';
import '../../../screen/login_page.dart';
import '../../../screen/search_page.dart';
import '../../../screen/setting_page.dart';
import '../../utils/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {

  final bool? doLogin;
  final String? username;
  late bool? showSearch;

  CommonAppBar({
    Key? key,
    this.doLogin,
    this.username,
    this.showSearch
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage()));
          },
          child: SvgPicture.asset('assets/logo.svg',
              height: 40, width: 55, fit: BoxFit.scaleDown),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: TextButton(
            onPressed: () {
              SideSheet.left(
                  body: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 20.0,
                      sigmaY: 20.0,
                    ),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 3, 37, 65)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 70, horizontal: 20),
                            child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text("Movies",
                                        style: TextStyle(
                                            fontSize: 20.8,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Popular",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Top Rated",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Upcoming",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Now Playing",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 20),
                                    const Text("TV Shows",
                                        style: TextStyle(
                                            fontSize: 20.8,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Popular",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Top Rated",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("On TV",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Airing Today",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 20),
                                    const Text("People",
                                        style: TextStyle(
                                            fontSize: 20.8,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Popular People",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    const SizedBox(height: 20),
                                    const Text("Contribution Bible",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("Apps",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("Discussions",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("Leader board",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("Contribute",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("API",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("Support",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 10),
                                    const Text("About",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                153, 255, 255, 255))),
                                    const SizedBox(height: 20),
                                    if (doLogin == false)
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const LoginPage()));
                                          },
                                          child: const Text("Log in",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Color.fromARGB(153,
                                                      255, 255, 255)))),
                                    if (doLogin == true)
                                      GestureDetector(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Do you want to log out"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            BlocProvider.of<
                                                                AppBloc>(
                                                                context)
                                                                .add(
                                                                Logout());
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "OK")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Cancel"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const Text("Log out",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  color: Color.fromARGB(153,
                                                      255, 255, 255)))),
                                  ],
                                )))),
                  ),
                  context: context);
            },
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        actions: [
          if (doLogin == false)
            PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'login') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  }
                  if (value == "setting") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingPage()));
                  }
                },
                offset: const Offset(0, kToolbarHeight),
                icon: const Icon(Icons.person, color: Colors.white),
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      child: Text("Login"), value: "login"),
                  const PopupMenuItem<String>(
                      child: Text("Sign up"), value: "sign"),
                  const PopupMenuItem<String>(
                      child: Text("Setting"), value: "setting")
                ]),
          if (doLogin == true)
            TextButton(
                onPressed: () {},
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                )),
          if (doLogin == true)
            PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "setting") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingPage()));
                  }
                  if (value == 'logout') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Do you want to log out"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    BlocProvider.of<AppBloc>(context)
                                        .add(Logout());
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"))
                            ],
                          );
                        });
                  }
                },
                offset: const Offset(0, kToolbarHeight),
                child: CircleAvatar(
                    backgroundColor:
                    const Color.fromARGB(255, 210, 144, 1),
                    radius: 16,
                    child: Text(username![0],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white))),
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      child: Text("Logout"), value: "logout"),
                  const PopupMenuItem<String>(
                      child: Text("Setting"), value: "setting")
                ]),
          showSearch == true
              ? TextButton(
              onPressed: () {
                showSearch = false;
              },
              child: const Icon(Icons.clear, color: Colors.white))
              : TextButton(
              onPressed: () {
                  showSearch = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchPage()));
              },
              child: const Icon(Icons.search,
                  color: Color.fromARGB(255, 1, 180, 228)))
        ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}