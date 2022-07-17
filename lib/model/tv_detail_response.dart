import 'package:tmdb_app/model/detail_info.dart';
import 'package:tmdb_app/model/list_info.dart';

import '../api/decodable.dart';

class TVDetailResponse implements Decodable<TVDetailResponse>, DetailInfo{
  TVDetailResponse();
  @override
  int id = 0;
  bool? adult;
  @override
  String? posterPath;
  @override
  String? backdropPath;
  String? name;
  @override
  String? originalTitle;
  @override
  String? releaseDate;
  @override
  double? vote;
  @override
  int? runTime;
  List<String>? genres;
  @override
  String? tagLine;
  @override
  String? overview;
  String? currentYear;
  String? nameSeason;
  int? episodeCount;
  @override
  String? status;
  String? type;
  List<dynamic>? network = [];
  @override
  String? originalLanguage;
  int? numberSeason;

  @override
   TVDetailResponse decode(dynamic json){
    id = json['id'];
    adult = json['adult'];
    posterPath = json['poster_path'];
    backdropPath = json['backdrop_path'];
    name = json['name'];
    originalTitle = json['original_name'];
    releaseDate = json['first_air_date'];
    vote = json['vote_average'];
    runTime = json['episode_run_time'][0];
    List l = json['genres'] as List;
    for (var e in l) {
      genres!.add(e['name']);
    }
    tagLine = json['tagline'];
    overview = json['overview'];
    numberSeason = json['number_of_seasons'];
    List seasons = json['seasons'] as List;
    Map<String,dynamic> currentSeason = seasons[numberSeason! - 1] ;
    currentYear = currentSeason['air_date'];
    nameSeason = 'Season $numberSeason';
    episodeCount = currentSeason ['episode_count'];
    status = json['status'];
    type = json['type'];
    network = json['networks'] ;
    originalLanguage = json['original_language'];
    return this;
  }
}