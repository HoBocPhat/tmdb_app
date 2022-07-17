import 'package:tmdb_app/model/detail_info.dart';
import 'package:tmdb_app/model/list_info.dart';

import '../api/decodable.dart';

class MovieDetailResponse implements Decodable<MovieDetailResponse>, DetailInfo{
  @override
  int id = 0;
  @override
  String? backdropPath;
  @override
  String? posterPath;
  String? title;
  @override
  String? originalTitle;
  @override
  double? vote;
  @override
  int? runTime;
  List<String>? genres;
  @override
  String? tagLine;
  @override
  String? overview;
  bool? video;
  @override
  String? status;
  @override
  String? originalLanguage;
  int? budget;
  int? revenue;
  @override
  String? releaseDate;

  @override
  MovieDetailResponse decode (dynamic json){
    id = json['id'];
    backdropPath = json['backdrop_path'];
    posterPath = json['poster_path'];
    title = json['title'];
    originalTitle = json['original_title'];
    vote = json['vote_average'];
    runTime = json['runtime'];
    tagLine = json['tagline'];
    overview = json['overview'];
    video = json['video'];
    status = json['status'];
    originalLanguage = json['original_language'];
    budget = json['budget'];
    revenue = json['revenue'];
    releaseDate = json['release_date'];
    List l = json['genres'] as List;
    for (var e in l) {
      genres!.add(e['name']);
    }

    return this;
  }
}