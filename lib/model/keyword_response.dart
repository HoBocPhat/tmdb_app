

import 'package:tmdb_app/api/decodable.dart';

class MovieKeyword implements Decodable<MovieKeyword>{
  MovieKeyword();
  late int id;
  List<String> keywords = [];

  @override
  MovieKeyword decode (dynamic json){
    id = json['id'];
    List l = json['keywords'] as List;
    for (var e in l) {
      keywords.add(e['name']);
    }
    return this;
  }
}

class TVKeyword implements Decodable<TVKeyword>{
  TVKeyword();
  late int id;
  List<String> keywords = [];

  @override
  TVKeyword decode (dynamic json){
    id = json['id'];
    List l = json['results'] as List;
    l.forEach((e) {
      keywords.add(e['name']);
    });
    return this;
  }
}