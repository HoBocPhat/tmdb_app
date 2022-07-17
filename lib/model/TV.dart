

import 'package:tmdb_app/model/list_info.dart';

import '../api/decodable.dart';

class TV implements Decodable<TV>, ListInfo{
  String? backdropPath;
  @override
  String? releaseDate;
  late List<int> genreId;
  @override
  int id = 0;
  late String name;
  late List<String> originCountry;
  late String originalLanguage;
  @override
  String? originalTitle;
  late String overview;
  late double popularity;
  @override
  String? posterPath;
  @override
  double? vote;
  late int voteCount;

  @override
  TV decode(dynamic json){
    backdropPath = json['backdrop_path'];
    releaseDate = json['first_air_date'];
    genreId = (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList();
    id = json['id'];
    name = json['name'];
    originCountry =
      (json['origin_country'] as List<dynamic>).map((e) => e as String).toList();
    originalLanguage = json['original_language'];
    originalTitle = json['original_name'];
    overview = json['overview'];
    popularity = (json['popularity'] as num).toDouble();
    posterPath = json['poster_path'];
    vote = (json['vote_average'] as num).toDouble();
    voteCount = json['vote_count'];
    return this;
  }

}
