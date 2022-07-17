import 'package:tmdb_app/api/decodable.dart';

class Video implements Decodable<Video>{
  Video();
  String? key;
  String? type;
  String? site;
  String? id;
  String? publish;

  @override
  Video decode (dynamic json){
    key = json['key'];
    site = json['site'];
    type = json['type'];
    publish = json['published_at'];
    id = json['id'];
    return this;
  }
}