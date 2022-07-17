import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_app/app/app_bloc.dart';

import 'package:tmdb_app/model/person_response.dart';
import 'package:tmdb_app/person/person_bloc.dart';

import 'package:tmdb_app/repository/api_repository.dart';

import '../commons/widgets/app_bar/detail_bar.dart';
import '../model/TV.dart';
import '../model/movie.dart';

class PersonDetailPage extends StatefulWidget {
  final int id;

  const PersonDetailPage( {Key? key, required this.id})
      : super(key: key);

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  late PersonBloc personBloc;
  late AppBloc appBloc;
  late ApiRepository apiRepo;
  late bool _doLogin = false;
  late String? username = '';
  late PersonResponse personResponse;
  late List<Movie> movies = [];
  late List<TV> tv = [];

  @override
  void initState() {
    super.initState();
    personResponse = PersonResponse();
    appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.add(GetUser());
    apiRepo = ApiRepository(appBloc.apiClient);
    personBloc = PersonBloc(apiRepo: apiRepo);
    personBloc.add(LoadPerson(widget.id));
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        bloc: appBloc,
        builder: (context, state) {
          if (state is Logined) {
            _doLogin = true;
            username = state.user?.username;
          } else if (state is Logouted) {
            _doLogin = false;
          }
          return Scaffold(
              appBar: DetailAppBar(doLogin: _doLogin, username: username),
              body:
              BlocProvider(
                create: (context) => personBloc,
                child: BlocConsumer<PersonBloc, PersonState>(
                  listener: (context, state) {
                    if(state is PersonLoaded){
                      personResponse = state.person;
                    }
                  },

                  builder: (context, state) {
                    if(state is PersonLoading){
                      return const Center(
                      child: CircularProgressIndicator());
                    }
                    else{
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PopupMenuButton<String>(
                                  onSelected: (value) {},
                                  offset: const Offset(0, 25),
                                  child: Row(
                                    children: const [
                                      Text("Overview",
                                          style: TextStyle(fontSize: 16)),
                                      Icon(Icons.arrow_drop_down_sharp)
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                        child: Text("Main"), value: "main"),
                                    const PopupMenuItem<String>(
                                        child: Text("Alternative Titles"),
                                        value: "alt_title"),
                                    const PopupMenuItem<String>(
                                        child: Text("Cast & Crew"),
                                        value: "cast"),
                                    const PopupMenuItem<String>(
                                        child: Text("Episode Groups"),
                                        value: "eps_gr"),
                                    const PopupMenuItem<String>(
                                        child: Text("Seasons"),
                                        value: "season"),
                                    const PopupMenuItem<String>(
                                        child: Text("Translation"),
                                        value: "trans"),
                                    const PopupMenuItem<String>(
                                        child: Text("Changes"),
                                        value: "changes"),
                                  ]),
                              PopupMenuButton<String>(
                                  onSelected: (value) {},
                                  offset: const Offset(0, 25),
                                  child: Row(
                                    children: const [
                                      Text("Media",
                                          style: TextStyle(fontSize: 16)),
                                      Icon(Icons.arrow_drop_down_sharp)
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                        child: Text("Backdrops"),
                                        value: "backdrop"),
                                    const PopupMenuItem<String>(
                                        child: Text("Logos"),
                                        value: "logo"),
                                    const PopupMenuItem<String>(
                                        child: Text("Posters"),
                                        value: "poster"),
                                    const PopupMenuItem<String>(
                                        child: Text("Videos"),
                                        value: "video"),
                                  ]),
                              PopupMenuButton<String>(
                                  onSelected: (value) {},
                                  offset: const Offset(0, 25),
                                  child: Row(
                                    children: const [
                                      Text("Fandom",
                                          style: TextStyle(fontSize: 16)),
                                      Icon(Icons.arrow_drop_down_sharp)
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                        child: Text("Discussions"),
                                        value: "discussion"),
                                    const PopupMenuItem<String>(
                                        child: Text("Reviews"),
                                        value: "review"),
                                  ]),
                              PopupMenuButton<String>(
                                  onSelected: (value) {},
                                  offset: const Offset(0, 25),
                                  child: Row(
                                    children: const [
                                      Text("Share",
                                          style: TextStyle(fontSize: 16)),
                                      Icon(Icons.arrow_drop_down_sharp)
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                        child: Text("Share Link"),
                                        value: "link"),
                                    const PopupMenuItem<String>(
                                        child: Text("Facebook"),
                                        value: "Facebook"),
                                    const PopupMenuItem<String>(
                                        child: Text("Tweet"),
                                        value: "tweet")
                                  ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                            children: [

                              Stack(
                                children: [
                                  Shimmer.fromColors(
                                      child: Container(
                                          height: 157,
                                          width: 157,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(10)),
                                          child:
                                          const Center(child: Icon(Icons.image))),
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!),
                                  Container(
                                width: 157,
                                height: 157,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              'https://www.themoviedb.org/t/p/w375_and_h375_face/${personResponse.profilePath}')),
                                      borderRadius: BorderRadius.circular(6)),
                            )],
                              ),
                            const SizedBox(
                              height: 20,
                            ),

                              Text('${personResponse.name}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 35.2),),



                            ]
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Text("Personal Info", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.8),),
                        ),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                            child: Text("Known for", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Text('${personResponse.knownFor}', style: const TextStyle(fontSize: 16))
                        ),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Gender", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Text('${personResponse.gender}', style: const TextStyle(fontSize: 16))
                        ),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Birthday", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Text("${personResponse.birthday} (${personResponse.age.toString()} years old)", style: TextStyle(fontSize: 16))
                        ),

                        if(personResponse.deathday != null)
                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("DeathDay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                        ),

                        if(personResponse.deathday != null)
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Text(personResponse.deathday!, style: const TextStyle(fontSize: 16))
                        ),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Place of Birth", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Text('${personResponse.birthPlace}', style: const TextStyle(fontSize: 16))
                        ),

                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Text("Biography", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.8),),
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Column(
                              children: [
                                Text('${personResponse.biography}', style: const TextStyle(fontSize: 16)),
                              ],
                            )
                        ),
                        ]
                    );}}
                    ),
              )
                );}
              );
        }


}