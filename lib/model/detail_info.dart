import 'package:tmdb_app/model/list_info.dart';

abstract class DetailInfo implements ListInfo{
  @override
  int id = 0;
  @override
  String? posterPath;
  @override
  double? vote;
  @override
  String? originalTitle;
  @override
  String? releaseDate;
  String? tagLine;
  String? overview;
  String? status;
  String? originalLanguage;
  int? runTime;
  String? backdropPath;
}