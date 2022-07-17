import 'package:tmdb_app/api/decodable.dart';
import 'package:tmdb_app/model/list_info.dart';

class MovieDemo extends ListInfo implements Decodable<MovieDemo> {
  String? backdropPath;
  @override
  String? releaseDate;
  late List<int> genreId;
  @override
  int id = 0;
  late String title;
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
  late bool adult;
  late bool video;

  @override
  MovieDemo decode(dynamic json){
    backdropPath = json['backdrop_path'];
    releaseDate = json['release_date'];
    genreId = (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList();
    id = json['id'];
    title = json['title'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = (json['popularity'] as num).toDouble();
    posterPath = json['poster_path'];
    vote = (json['vote_average'] as num).toDouble();
    voteCount = json['vote_count'];
    adult = json['adult'];
    video = json['video'];
    return this;
  }
}