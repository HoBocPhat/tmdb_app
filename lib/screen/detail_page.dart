import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_app/app/app_bloc.dart';
import 'package:tmdb_app/commons/widgets/listview/content_detail.dart';
import 'package:tmdb_app/detail/detail_bloc.dart';
import 'package:tmdb_app/model/TV.dart';

import 'package:tmdb_app/model/keyword_response.dart';
import 'package:tmdb_app/model/movie_detail_response.dart';
import 'package:tmdb_app/model/tv_detail_response.dart';
import 'package:tmdb_app/model/video_response.dart';
import 'package:tmdb_app/repository/api_repository.dart';
import 'package:tmdb_app/screen/person_detail.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../commons/widgets/app_bar/detail_bar.dart';
import '../model/cast.dart';
import '../model/detail_info.dart';
import '../model/keyword_response.dart';

import '../model/movie_demo.dart';

import 'package:tmdb_app/screen/home_page.dart';

class DetailPage extends StatefulWidget {
  late int id;
  final String type;

  DetailPage({Key? key, required this.id, required this.type})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DetailInfo detailInfo;
  late DetailBloc detailBloc;
  late AppBloc appBloc;
  late ApiRepository apiRepo;
  late bool _doLogin = false;
  late String? username = '';
  late TVDetailResponse tvDetail;
  late List<Cast> cast = [];
  late MovieKeyword movieKeyword;
  late List<TV> tv = [];

  late MovieDetailResponse movieDetail;
  late List<MovieDemo> movie = [];
  late TVKeyword tvKeyword;
  late int trackColor = 0;
  late int progressColor = 0;
  late YoutubePlayerController youtubeController;

  late Video trailer;
  late Video trailerMovie;
  late String url = 'https://www.youtube.com/watch?v=';


  @override
  void initState() {
    super.initState();
    appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.add(GetUser());
    tvDetail = TVDetailResponse();

    movieKeyword = MovieKeyword();
    movieDetail = MovieDetailResponse();
    tvKeyword = TVKeyword();
    apiRepo = ApiRepository(appBloc.apiClient);
    detailBloc = DetailBloc(
      apiRepo: apiRepo,
    );
    trailer = Video();
    trailerMovie = Video();
    youtubeController = YoutubePlayerController(initialVideoId: url);
    if (widget.type == 'tv') {
      detailBloc
        ..add(LoadTVDetail(widget.id))
        ..add(LoadTVRed(widget.id))
        ..add(LoadCreditTV(widget.id))
        ..add(LoadKeywordTV(widget.id))
        ..add(LoadTrailerTV(widget.id));
    } else if (widget.type == 'movie') {
      detailBloc
        ..add(LoadMovieDetail(widget.id))
        ..add(LoadMovieRe(widget.id))
        ..add(LoadCreditMovie(widget.id))
        ..add(LoadKeywordMovie(widget.id))
        ..add(LoadTrailerMovie(widget.id));
    }
  }

  @override
  void deactivate() {
    youtubeController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubeController.dispose();
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
              bottomNavigationBar: BottomAppBar(
                  color: const Color.fromARGB(255, 3,37,65),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: const Icon(Icons.home), onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()));
                      }, color: Colors.white),
                      IconButton(icon: const Icon(Icons.list), onPressed: () {}, color: Colors.white),
                      IconButton(icon: const Icon(Icons.favorite), onPressed: () {}, color: Colors.white),
                      IconButton(icon: const Icon(Icons.bookmark), onPressed: () {}, color: Colors.white),
                      IconButton(icon: const Icon(Icons.star), onPressed: () {  }, color: Colors.white)
                    ],
                  )
              ),
              body: BlocProvider(
                create: (context) => detailBloc,
                child: BlocConsumer<DetailBloc, DetailState>(
                  listener: (context, state) {
                    if (state is DetailTVLoaded) {
                      tvDetail = state.tvDetailResponse;
                      getColor(tvDetail.vote!);
                    } else if (state is DetailMovieLoaded) {
                      movieDetail = state.movieDetailResponse;
                      getColor(movieDetail.vote!);
                    }
                    if (state is TVKeywordLoaded) {
                      tvKeyword = state.keyword;
                    } else if (state is MovieKeywordLoaded) {
                      movieKeyword = state.keyword;
                    }
                    if (state is CreditLoaded) {
                      cast = state.cast;
                    }
                    if (state is TVReLoaded) {
                      tv = state.tv;
                    } else if (state is MovieReLoaded) {
                      movie = state.movie;
                    }
                    if (state is TrailerLoaded) {
                      trailer = state.video;
                      youtubeController = YoutubePlayerController(
                          initialVideoId: trailer.key!,
                          flags: const YoutubePlayerFlags(
                              mute: false, autoPlay: true, loop: false));
                    }
                  },
                  builder: (context, state) {
                    if(state is DetailMovieLoading){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                    return ListView(
                      children: [
                        if(widget.type == "tv")
                        RenderDetailContent(detailInfo: tvDetail, progressColor: progressColor, trackColor: trackColor),
                        if(widget.type == "movie")
                          RenderDetailContent(detailInfo: movieDetail, progressColor: progressColor, trackColor: trackColor),
                        if (widget.type == "tv")
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Text("Series Cast",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19.2)),
                          ),
                        //movie
                        if (widget.type == "movie")
                          const Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Text("Top Billed Cast",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19.2)),
                          ),
                        SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            PersonDetailPage(id: cast[index].id)));
                                  },
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: SizedBox(
                                        width: 150,
                                        child: Card(
                                            elevation: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Shimmer.fromColors(
                                                        child: Container(
                                                            width: 150,
                                                            height: 180,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color:
                                                                    Colors.black),
                                                                borderRadius:
                                                                const BorderRadius
                                                                    .vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                        6),
                                                                    bottom: Radius
                                                                        .zero)),
                                                            child: const Center(
                                                                child: Icon(Icons.image))),
                                                        baseColor: Colors.grey[300]!,
                                                        highlightColor: Colors.grey[100]!),
                                                    Container(
                                                      width: 150,
                                                      height: 180,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  'https://www.themoviedb.org/t/p/w240_and_h266_face${cast[index].profilePath}')),
                                                          borderRadius: const BorderRadius
                                                              .vertical(
                                                              top: Radius.circular(6),
                                                              bottom: Radius.zero)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            10, 0, 10, 10),
                                                    child: Text(
                                                        "${cast[index].name}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight
                                                                .bold))),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            10, 0, 10, 10),
                                                    child: Text(
                                                        "${cast[index].character}",
                                                        style: const TextStyle(
                                                            fontSize: 14.4))),
                                              ],
                                            )),
                                      )),
                                );
                              },
                              itemCount: cast.length,
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                            )
                        ),

                        const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Full Cast & Crew",
                                style: TextStyle(
                                    fontSize: 17.6,
                                    fontWeight: FontWeight.w600))),

                        const Divider(),
                        if (widget.type == 'tv')
                          const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("Current Season",
                                  style: TextStyle(
                                      fontSize: 19.2,
                                      fontWeight: FontWeight.w600))),
                        //TV
                        if (widget.type == 'tv')
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 30, 20, 10),
                                        child: Text(
                                            "Season ${tvDetail.numberSeason}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 24))),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 30),
                                        child: Text(
                                            '${tvDetail.currentYear} | ${tvDetail.episodeCount} Episodes',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600))),
                                  ],
                                ),
                              )),
                        //TV
                        if (widget.type == 'tv')
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text("View All Seasons",
                                  style: TextStyle(
                                      fontSize: 17.6,
                                      fontWeight: FontWeight.w600))),

                        const Divider(),

                        const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Trailer",
                                style: TextStyle(
                                    fontSize: 19.2,
                                    fontWeight: FontWeight.w600))),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: SizedBox(
                            height: 250,
                            child: YoutubePlayerBuilder(
                              player: YoutubePlayer(
                                controller: youtubeController,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.red,
                                progressColors: const ProgressBarColors(
                                  playedColor: Colors.red,
                                  handleColor: Colors.redAccent,
                                ),
                                onReady: () {
                                  youtubeController.addListener(() {});
                                },
                              ),
                              builder: (context, player) => player,
                            ),
                          ),
                        ),

                        const Divider(),
                        const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("Recommendations",
                                style: TextStyle(
                                    fontSize: 19.2,
                                    fontWeight: FontWeight.w600))),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: SizedBox(
                              height: 250,
                              child: widget.type == 'movie'
                                  ? _renderRecommendMovie(movie)
                                  : _renderRecommendTV(tv)),
                        ),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Facts",
                                style: TextStyle(
                                    fontSize: 17.6,
                                    fontWeight: FontWeight.w600))),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Status",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: widget.type == 'movie'
                                ? Text("${movieDetail.status}",
                                    style: const TextStyle(fontSize: 16))
                                : Text("${tvDetail.status}",
                                    style: const TextStyle(fontSize: 16))),
                        if (widget.type == 'tv')
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Text("Network",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        if (widget.type == 'tv')
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Wrap(
                                children:
                                    _renderNetwork(context, tvDetail.network),
                              )),
                        if (widget.type == 'tv')
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Text("Type",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        if (widget.type == 'tv')
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text("${tvDetail.type}",
                                  style: TextStyle(fontSize: 16))),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Original language",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                            child: widget.type == 'movie'
                                ? Text("${movieDetail.originalLanguage}",
                                    style: const TextStyle(fontSize: 16))
                                : Text("${tvDetail.originalLanguage}",
                                    style: const TextStyle(fontSize: 16))),
                        //Movie
                        if (widget.type == 'movie')
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Text("Budget",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        //Movie
                        if (widget.type == 'movie')
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                              child: Text("${movieDetail.budget}",
                                  style: const TextStyle(fontSize: 16))),
                        //Movie
                        if (widget.type == 'movie')
                          const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Text("Revenue",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))),
                        //Movie
                        if (widget.type == 'movie')
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                              child: Text("${movieDetail.revenue} USD",
                                  style: TextStyle(fontSize: 16))),

                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text("Keywords",
                                style: TextStyle(
                                    fontSize: 17.6,
                                    fontWeight: FontWeight.w600))),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                            child: widget.type == "movie"
                                ? Wrap(
                                    direction: Axis.horizontal,
                                    children: _renderKeyword(
                                        context, movieKeyword.keywords))
                                : Wrap(
                                    direction: Axis.horizontal,
                                    children: _renderKeyword(
                                        context, tvKeyword.keywords))),
                        const Divider(),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                            child: Text("Content Score",
                                style: TextStyle(
                                    fontSize: 17.6,
                                    fontWeight: FontWeight.w600))),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 38,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    left: Radius.circular(6),
                                                    right: Radius.zero),
                                            color: Colors.grey[300],
                                          ),
                                        )),
                                    Flexible(
                                        flex: 2,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 38,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    left: Radius.zero,
                                                    right: Radius.circular(6)),
                                            color: Colors.grey[500],
                                          ),
                                        ))
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 11, 0, 11),
                                    child: widget.type == 'movie'
                                        ? Text(
                                            "${movieDetail.vote ?? 0 * 10}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600))
                                        : Text("${tvDetail.vote ?? 0 * 10}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)))
                              ],
                            )),
                      ],
                    );}
                  },
                ),
              ));
        });
  }

  List<Card> _renderKeyword(BuildContext context, List<String> keywords) {
    return List.generate(keywords.length, (index) {
      return Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text("${keywords[index]}",
                style: const TextStyle(fontSize: 12.9)),
          ));
    });
  }

  List<Padding> _renderNetwork(BuildContext context, List<dynamic>? network) {
    return List.generate(network!.length, (index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: Container(
          height: 30,
          width: 55,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(
                    'https://www.themoviedb.org/t/p/h60${network[index]['logo_path']}')),
          ),
        ),
      );
    });
  }

  List<Padding> _renderGenres(BuildContext context, List<String> genres) {
    return List.generate(genres.length, (index) {
      return Padding(
          padding: const EdgeInsets.all(5), child: Text("${genres[index]}"));
    });
  }

  Widget _renderText({String? content, TextStyle? style}) {
    content ??= " ";

    return Text(content, style: style);
  }

  Widget _renderBackdrop(
      {TVDetailResponse? tvDetail, MovieDetailResponse? movieDetail}) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://www.themoviedb.org/t/p/original/${movieDetail?.backdropPath}')),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 0, 20),
            child: Container(
              width: 92,
              height: 140,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://www.themoviedb.org/t/p/original/${movieDetail?.posterPath}'),
                  ),
                  borderRadius: BorderRadius.circular(6)),
            ))
      ],
    );
  }

  void getColor(double percent) {
    if (percent >= 6 && percent <= 10) {
      progressColor = 0xff21d07a;
      trackColor = 0xff204529;
    } else if (percent >= 4 && percent <= 5.9) {
      progressColor = 0xffd2d531;
      trackColor = 0xff423d0f;
    } else {
      progressColor = 0xffdb2360;
      trackColor = 0xff571435;
    }
  }
  Widget _renderRecommendMovie(List<MovieDemo> movie) {
    return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(id: movie[index].id, type: 'movie')));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Shimmer.fromColors(child: Container(
                        width: 250,
                        height: 141,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black)
                        ),
                        child: const Center(
                          child: Icon(Icons.image)
                        ),
                      ),

                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!),

                      Container(
                        width: 250,
                        height: 141,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://www.themoviedb.org/t/p/w500_and_h282_face${movie[index].backdropPath}')),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 250,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: Text("${movie[index].originalTitle}",
                                  style: const TextStyle(fontSize: 16))),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text("  ${(movie[index].vote! * 10).round()}%",
                                  style: const TextStyle(fontSize: 16)))
                        ],
                      )),
                ],
              ),
            ));
      },
      itemCount: movie.length,
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _renderRecommendTV(List<TV> tv) {
    return ListView.builder(
      itemBuilder: (BuildContext context, index) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(id: tv[index].id, type: 'tv')));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Shimmer.fromColors(child: Container(
                        width: 250,
                        height: 141,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black)
                        ),
                        child: const Center(
                            child: Icon(Icons.image)
                        ),
                      ),

                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!),

                      Container(
                        width: 250,
                        height: 141,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    'https://www.themoviedb.org/t/p/w500_and_h282_face${tv[index].backdropPath}')),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 250,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: Text("  ${tv[index].originalTitle!}",
                                  style: const TextStyle(fontSize: 16))),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text("${(tv[index].vote! * 10).round() }%",
                                  style: const TextStyle(fontSize: 16)))
                        ],
                      )),
                ],
              ),
            ));
      },
      itemCount: tv.length,
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
    );
  }
}

