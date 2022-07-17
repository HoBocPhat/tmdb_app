
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:shimmer/shimmer.dart';
import 'package:tmdb_app/app/app_bloc.dart';
import 'package:tmdb_app/commons/widgets/listview/list_homepage.dart';
import 'package:tmdb_app/model/movie_demo.dart';
import 'package:tmdb_app/model/trending_response.dart';
import 'package:tmdb_app/model/user.dart';
import 'package:tmdb_app/popular/popular_bloc.dart';
import 'package:tmdb_app/repository/api_repository.dart';


import '../commons/widgets/app_bar/app_bar.dart';
import '../model/TV.dart';

import 'package:flutter/material.dart';
import 'dart:ui';

import '../model/movie_detail_response.dart';
import '../model/tv_detail_response.dart';
import 'detail_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController controllerMovie = ScrollController();
  late ScrollController controllerTV = ScrollController();

  String dropdownPopularValue = 'On TV';
  String dropdownTrailerValue = 'On TV';
  String dropdownTrendingValue = 'Today';
  int moviePage = 1;
  int tvPage = 1;
  List<TVDetailResponse> popularTV = [];
  List<MovieDetailResponse> popularMovie = [];

  Timer? _debounce;

  List<TVDetailResponse> trendingTV = [];
  List<MovieDetailResponse> trendingMovie = [];

  late bool? _doLogin = false;
  late String? username = '';
  late User user;
  late ApiRepository apiRepo;
  late PopularBloc popularBloc;
  late AppBloc appBloc;
  late TextEditingController searchController;
  final _formKey = GlobalKey<FormState>();


  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

  }

  void onScrollMovie() {
    final maxScroll = controllerMovie.position.maxScrollExtent;
    final currentScroll = controllerMovie.position.pixels;
    if (maxScroll - currentScroll <= 10) {
      popularBloc.add(LoadMoreMovie(moviePage));
      moviePage += 1;
    }
  }

  void onScrollTV() {
    final maxScroll = controllerTV.position.maxScrollExtent;
    final currentScroll = controllerTV.position.pixels;
    if (maxScroll - currentScroll <= 10) {
      popularBloc.add(LoadMoreTV(tvPage));
      tvPage += 1;
    }
  }

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    apiRepo = ApiRepository(appBloc.apiClient);
    popularBloc = PopularBloc(apiRepo: apiRepo);
    controllerMovie.addListener(onScrollMovie);
    controllerTV.addListener(onScrollTV);
    appBloc.add(GetUser());
    popularBloc
      ..add(TVLoad())
      ..add(TrendingTodayTVLoad());
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        bloc: BlocProvider.of<AppBloc>(context),
        builder: (context, state) {
          if (state is Logined) {
            _doLogin = true;
            username = state.user?.username;
          } else if (state is Logouted) {
            _doLogin = false;
          }
          return Scaffold(
              appBar: CommonAppBar(doLogin: _doLogin,username: username),
              body: BlocProvider(
                  create: (context) => popularBloc,
                  child: BlocConsumer<PopularBloc, PopularState>(
                    listener: (context, state) {
                      if (state is TVLoaded) {
                        popularTV = state.tvs;
                      } else if (state is MovieLoaded) {
                        //popularMovie = state.movies;
                        popularMovie = state.movies;
                      }
                      if (state is TrendingTVLoaded) {
                        trendingTV = state.tvs;
                      } else if (state is TrendingMovieLoaded) {
                        trendingMovie = state.movies;
                      }
                      if (state is LoadedMovieMore) {
                        popularMovie.addAll(state.listMore);
                      } else if (state is LoadedTVMore) {
                        popularTV.addAll(state.listMore);
                      }
                    },
                    builder: (context, state) {
                      return ListView(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 360,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage('assets/bg.jpg'))),
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Welcome.",
                                          style: Theme.of(context).textTheme.headline1?.copyWith(color: Colors.white)),
                                      Text(
                                          "Millions of movies, TV shows and people to discover. Explore now.",
                                          style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ])),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
                            child: Row(
                              children: [
                                Text("Filter",
                                    style: Theme.of(context).textTheme.headline4),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                    height: 30,
                                    child: DecoratedBox(
                                      decoration: const ShapeDecoration(
                                          color: Color.fromARGB(255, 3, 37, 65),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0)))),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 0, 10.0, 0),
                                          child: BlocBuilder<PopularBloc,
                                                  PopularState>(
                                            bloc: popularBloc,
                                              builder: (context, state) {
                                            return DropdownButton<String>(
                                                value: dropdownPopularValue,
                                                items: <String>[
                                                  'On TV',
                                                  'In Theaters'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ));
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue == "On TV") {
                                                    if(dropdownTrendingValue == "Today"){
                                                      popularBloc.add(TrendingTodayTVLoad());
                                                    }
                                                    else if(dropdownTrendingValue == "This week"){
                                                      popularBloc.add(TrendingWeekTVLoad());
                                                    }
                                                    // if (_debounce?.isActive ?? false) _debounce?.cancel();
                                                    // _debounce = Timer(const Duration(milliseconds: 5000), () {
                                                    //   popularBloc.add(TVLoad());
                                                    //   if(dropdownTrendingValue == "Today"){
                                                    //     popularBloc.add(TrendingTodayTVLoad());
                                                    //   }
                                                    //   else if(dropdownTrendingValue == "This week"){
                                                    //     popularBloc.add(TrendingWeekTVLoad());
                                                    //   }
                                                    // });

                                                  }
                                                  else if (newValue ==
                                                      "In Theaters") {
                                                    popularBloc.add(MovieLoad());
                                                    if(dropdownTrendingValue == "Today"){
                                                      popularBloc.add(TrendingTodayMovieLoad());
                                                    }
                                                    else if(dropdownTrendingValue == "This week"){
                                                      popularBloc.add(TrendingWeekMovieLoad());
                                                    }
                                                    // if (_debounce?.isActive ?? false) _debounce?.cancel();
                                                    // _debounce = Timer(const Duration(milliseconds: 5000), () {
                                                    //   popularBloc.add(MovieLoad());
                                                    //   if(dropdownTrendingValue == "Today"){
                                                    //     popularBloc.add(TrendingTodayMovieLoad());
                                                    //   }
                                                    //   else if(dropdownTrendingValue == "This week"){
                                                    //     popularBloc.add(TrendingWeekMovieLoad());
                                                    //   }
                                                    // });

                                                  }
                                                  setState(() {
                                                    dropdownPopularValue =
                                                        newValue!;
                                                  });
                                                },
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                underline: Container(),
                                                dropdownColor:
                                                    const Color.fromARGB(
                                                        255, 3, 37, 65),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0));
                                          })),
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
                             child: Text("What is Popular",
                                 style: Theme.of(context).textTheme.headline4),
                          ),
                          BlocBuilder<PopularBloc, PopularState>(
                              builder: (context, state) {
                            if (dropdownPopularValue == "On TV") {
                              return RenderListHome(list: popularTV);
                            } else if (dropdownPopularValue == "In Theaters") {
                              return RenderListHome(list: popularMovie);
                            } else {
                              return const SizedBox();
                            }
                          }),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 3, 37, 65)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 30.0),
                                    child: Row(
                                      children: [
                                        Text("Last Trailers",
                                            style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white)),
                                        const SizedBox(width: 20),
                                        SizedBox(
                                            height: 30,
                                            child: DecoratedBox(
                                              decoration: const ShapeDecoration(
                                                  color: Color.fromARGB(
                                                      255, 30, 213, 169),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30.0)))),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10.0, 0, 10.0, 0),
                                                  child: DropdownButton<String>(
                                                      value:
                                                          dropdownTrailerValue,
                                                      items: <String>[
                                                        'On TV',
                                                        'In Theaters'
                                                      ].map<DropdownMenuItem<String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                                String>(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ));
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          dropdownTrailerValue =
                                                              newValue!;
                                                        });
                                                      },
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                      underline: Container(),
                                                      dropdownColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              30,
                                                              213,
                                                              169),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                            )),
                                      ],
                                    )),
                                const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 30.0),
                                    child: Text(
                                        "This panel didn't return any results. Try refreshing it.",
                                        style: TextStyle(color: Colors.white)))
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0),
                            child: Row(
                              children: [
                                Text("Trending",
                                    style: Theme.of(context).textTheme.headline4),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                    height: 30,
                                    child: DecoratedBox(
                                      decoration: const ShapeDecoration(
                                          color: Color.fromARGB(255, 3, 37, 65),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0)))),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10.0, 0, 10.0, 0),
                                          child: BlocBuilder<PopularBloc,
                                                  PopularState>(
                                              builder: (context, state) {
                                            return DropdownButton<String>(
                                                value: dropdownTrendingValue,
                                                items: <String>[
                                                  'Today',
                                                  'This week'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ));
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue == "Today") {
                                                    if(dropdownPopularValue == "On TV"){
                                                      popularBloc.add(TrendingTodayTVLoad());
                                                    }
                                                    else if(dropdownPopularValue == "In Theaters"){
                                                      popularBloc.add(TrendingTodayMovieLoad());
                                                    }
                                                    // if (_debounce?.isActive ?? false) _debounce?.cancel();
                                                    // _debounce = Timer(const Duration(milliseconds: 5000), () {
                                                    //   if(dropdownPopularValue == "On TV"){
                                                    //     popularBloc.add(TrendingTodayTVLoad());
                                                    //   }
                                                    //   else if(dropdownPopularValue == "In Theaters"){
                                                    //     popularBloc.add(TrendingTodayMovieLoad());
                                                    //   }
                                                    // });

                                                  } else if (newValue ==
                                                      "This week") {
                                                    if(dropdownPopularValue == "On TV"){
                                                      popularBloc.add(TrendingWeekTVLoad());
                                                    }
                                                    else if(dropdownPopularValue == "In Theaters"){
                                                      popularBloc.add(TrendingWeekMovieLoad());
                                                    }
                                                    // if (_debounce?.isActive ?? false) _debounce?.cancel();
                                                    // _debounce = Timer(const Duration(milliseconds: 5000), () {
                                                    //   if(dropdownPopularValue == "On TV"){
                                                    //     popularBloc.add(TrendingWeekTVLoad());
                                                    //   }
                                                    //   else if(dropdownPopularValue == "In Theaters"){
                                                    //     popularBloc.add(TrendingWeekMovieLoad());
                                                    //   }
                                                    // });

                                                  }
                                                  setState(() {
                                                    dropdownTrendingValue =
                                                        newValue!;
                                                  });
                                                },
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                underline: Container(),
                                                dropdownColor:
                                                    const Color.fromARGB(
                                                        255, 3, 37, 65),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0));
                                          })),
                                    ))
                              ],
                            ),
                          ),
                          BlocBuilder<PopularBloc, PopularState>(
                              builder: (context, state) {
                            if (dropdownPopularValue == 'On TV') {
                              return RenderListHome(list: trendingTV);
                            } else if (dropdownPopularValue == 'In Theaters') {
                              return RenderListHome(list: trendingMovie);
                            } else {
                              return const SizedBox();
                            }
                          }),
                          if(_doLogin == false)
                          Container(
                              height: 600,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://www.themoviedb.org/t/p/w1920_and_h800_multi_faces_filter(duotone,190235,ad47dd)/lMnoYqPIAVL0YaLP5YjRy7iwaYv.jpg')),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30.0, horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Join today",
                                        style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white)),
                                    const SizedBox(height: 30),
                                    Wrap(children: [
                                      RichText(
                                          text: const TextSpan(
                                              style: TextStyle(
                                                  fontSize: 19.2,
                                                  color: Colors.white),
                                              children: [
                                            TextSpan(
                                                text:
                                                    "Get access to maintain your own "),
                                            TextSpan(
                                                text:
                                                    "custom personal lists, track what you've seen ",
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            TextSpan(
                                                text:
                                                    "and search and filter for  "),
                                            TextSpan(
                                                text: "what to watch next ",
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic)),
                                            TextSpan(
                                                text:
                                                    " - regardless if it's in theaters on TV or avaiable on popular streaming services like.")
                                          ]))
                                    ]),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Sign up ",
                                            style: TextStyle(
                                                fontSize: 14.4,
                                                fontWeight: FontWeight.w600)),
                                        style: ElevatedButton.styleFrom(
                                            primary: const Color.fromARGB(
                                                255, 128, 91, 231))),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text("Enjoy TMDB and free",
                                        style: TextStyle(
                                            fontSize: 19.2,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text(
                                        "Maintain a personal watch lists",
                                        style: TextStyle(
                                            fontSize: 19.2,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      children: const [
                                        Text(
                                            "Filter by your subscribed streaming services and find something to watch",
                                            style: TextStyle(
                                                fontSize: 19.2,
                                                color: Colors.white))
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                        "Log the movie and TV shows you've seen",
                                        style: TextStyle(
                                            fontSize: 19.2,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text("Build custom lists",
                                        style: TextStyle(
                                            fontSize: 19.2,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    const Text(
                                        "Contribute to and improve our database",
                                        style: TextStyle(
                                            fontSize: 19.2,
                                            color: Colors.white))
                                  ],
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20),
                              child: Row(
                                children: [
                                  Text("Leader board",
                                      style: Theme.of(context).textTheme.headline4),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(255, 30, 213, 169),
                                              Color.fromARGB(255, 1, 180, 228)
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text("All Time Edits",
                                            style: TextStyle(fontSize: 14.4)),
                                      ]),
                                      Row(children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 253, 193, 112),
                                              Color.fromARGB(255, 217, 59, 99)
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text("Edits This Week",
                                            style: TextStyle(fontSize: 14.4)),
                                      ]),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 3, 37, 65)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text("JOIN THE COMMUNITY",
                                            style: Theme.of(context).textTheme.headline4?.copyWith(
                                                color: const Color(0xff235ea7))),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white)),
                                    const SizedBox(height: 40),
                                    Text("THE BASICS",
                                        style: Theme.of(context).textTheme.headline4?.copyWith(
                                          color: Colors.white)),
                                    Text("About TMDB",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Contact Us",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Support Forums",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("API",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    const SizedBox(height: 30),
                                    Text("GET INVOLVED",
                                        style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: Colors.white)),
                                    Text("Contribute Bible",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Add A New Movie",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Add New TV Show",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    const SizedBox(height: 30),
                                    Text("COMMUNITY",
                                        style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: Colors.white)),
                                    Text("Guidelines",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Discussions",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Leader board",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Twitter",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    const SizedBox(height: 30),
                                    Text("LEGAL",
                                        style: Theme.of(context).textTheme.headline4?.copyWith(
                                            color: Colors.white)),
                                    Text("Terms of Use",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("API Terms of Use",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                    Text("Privacy Policy",
                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.normal)),
                                  ]),
                            ),
                          )
                        ],
                        scrollDirection: Axis.vertical,
                      );
                    },
                  )));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}


