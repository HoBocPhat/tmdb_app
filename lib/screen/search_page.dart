import 'dart:async';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/model/search_response.dart';
import 'package:tmdb_app/repository/api_repository.dart';
import 'package:tmdb_app/screen/person_detail.dart';


import '../app/app_bloc.dart';
import '../commons/widgets/app_bar/detail_bar.dart';
import '../model/TV.dart';
import '../model/movie_demo.dart';
import '../model/person_response.dart';
import '../model/user.dart';
import '../search/search_bloc.dart';
import 'detail_page.dart';


class SearchPage extends StatefulWidget {
  String? query;
  SearchPage({Key? key, String? query}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late bool? _doLogin = false;
  late String? username = '';
  late User user;
  late AppBloc appBloc;
  late List<SearchResponse> suggest = [];
  late List<SearchResponse> all = [];
  late SearchBloc searchBloc;
  late ApiRepository apiRepo;
  late TextEditingController _controller;
  late bool showSearch = true;
  int searchPage = 1;
  late ScrollController controllerSearch = ScrollController();
  String query = '';

  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      searchBloc.add(Searching(query));
    });
  }

  void onScrollSearch() {
    final maxScroll = controllerSearch.position.maxScrollExtent;
    final currentScroll = controllerSearch.position.pixels;
    if (maxScroll - currentScroll <= 30) {
      searchBloc.add(SearchMore(searchPage, query));
      searchPage += 1;
    }
  }

  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.add(GetUser());
    apiRepo = ApiRepository(appBloc.apiClient);
    searchBloc = SearchBloc(apiRepo: apiRepo);
    _controller = TextEditingController();
    controllerSearch.addListener(onScrollSearch);
    if(widget.query != null){
      searchBloc.add(SearchAll(widget.query!));
    }
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
              appBar: DetailAppBar(doLogin: _doLogin, username: username, showSearch: true),
              body: BlocProvider<SearchBloc>(
                create: (context) => searchBloc,
                child: BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) {
                    if (state is Searched) {
                      suggest = state.result;
                    }
                    if (state is SearchedAll) {
                      all = state.result;
                    }
                    if (state is SearchedMore) {
                      all.addAll(state.result);
                    }
                  },
                  builder: (context, state) {
                    return ListView(
                      controller:  controllerSearch,
                      children: [
                        if (showSearch == true)
                          Container(
                            height: 44,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              child: Row(
                                children: [
                                  const Icon(Icons.search),
                                  const SizedBox(width: 10),
                                  Expanded(child:
                                      BlocBuilder<SearchBloc, SearchState>(
                                          builder: (context, state) {
                                    return TextField(
                                        controller: _controller,
                                        decoration:
                                            const InputDecoration.collapsed(
                                                hintText: "Search",
                                                hintStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.grey)),
                                        onChanged: (value) {
                                          _onSearchChanged(value);

                                        },
                                        onSubmitted: (value) {
                                          searchBloc.add(SearchAll(value));
                                          query = value;
                                        },
                                        textInputAction:
                                            TextInputAction.search);
                                  })),
                                  TextButton(
                                      onPressed: () {
                                        _controller.clear();
                                        searchBloc.add(Searching(""));
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                              if (state is Searched) {
                                return ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Wrap(
                                      children: [
                                        if (suggest[index].result.runtimeType == TV)
                                          const Icon(Icons.tv),
                                        if (suggest[index].result.runtimeType == MovieDemo)
                                          const Icon(Icons.movie),
                                        if (suggest[index].result.runtimeType ==
                                            PersonResponse)
                                          const Icon(Icons.person),
                                        const SizedBox(width: 6),
                                        if (suggest[index].result.runtimeType == TV)
                                          GestureDetector(
                                            child: Text(
                                                suggest[index].result.originalName,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPage(id: suggest[index].result.id, type: "tv")));
                                            },
                                          ),
                                        if (suggest[index].result.runtimeType == MovieDemo)
                                          GestureDetector(
                                            child: Text(
                                                suggest[index].result.originalTitle,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPage(id: suggest[index].result.id, type: "movie")));
                                            },
                                          ),
                                        if (suggest[index].result.runtimeType ==
                                            PersonResponse)
                                          GestureDetector(
                                            child: Text(suggest[index].result.name,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PersonDetailPage(id: suggest[index].result.id)));
                                            },
                                          )
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider();
                                  },
                                  itemCount: suggest.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                );
                              } else if (all != []) {
                                return ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if(all[index].result.runtimeType == TV){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(id: suggest[index].result.id, type: "tv")));
                                        }
                                        else if(all[index].result.runtimeType == MovieDemo){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(id: suggest[index].result.id, type: "movie")));
                                        }
                                        else{
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PersonDetailPage(id: suggest[index].result.id)));
                                        }
                                      },
                                      child: Card(
                                        elevation: 5,
                                        child: Row(
                                          children: [
                                            if (all[index].result.runtimeType == TV ||
                                                all[index].result.runtimeType ==
                                                    MovieDemo)
                                              Container(
                                                width: 94,
                                                height: 141,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            'https://www.themoviedb.org/t/p/w260_and_h390_bestv2${all[index].result.posterPath}'))),
                                              ),
                                            if (all[index].result.runtimeType == TV ||
                                                all[index].result.runtimeType ==
                                                    MovieDemo)
                                            const SizedBox(width: 20),
                                            if (all[index].result.runtimeType ==
                                                MovieDemo)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        all[index].result
                                                            .originalTitle,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600)),
                                                    Text(
                                                        all[index].result.releaseDate,
                                                        style: const TextStyle(
                                                            fontSize: 14.4,
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ),
                                            if (all[index].result.runtimeType == TV)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        all[index].result
                                                            .originalName,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600)),
                                                    Text(
                                                        all[index].result
                                                            .firstAirDate,
                                                        style: const TextStyle(
                                                            fontSize: 14.4,
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ),
                                            if (all[index].result.runtimeType == PersonResponse)
                                              Container(
                                                  width: 94,
                                                  height: 141,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            'https://www.themoviedb.org/t/p/w260_and_h390_bestv2${all[index].result.profilePath}')),
                                                  )),
                                            if (all[index].result.runtimeType == PersonResponse)
                                              const SizedBox(width: 20),
                                            if (all[index].result.runtimeType == PersonResponse)
                                              Expanded(
                                                child:
                                                    Text("${all[index].result.name}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600)),

                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  // separatorBuilder: (context, index) {
                                  //   return const SizedBox();
                                  // },
                                  itemCount: all.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 5);
                                  },
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                );
                              } else {
                                return SizedBox();
                              }
                            })),
                      ],
                      scrollDirection: Axis.vertical,
                    );
                  },
                ),
              ));
        });
  }
}
