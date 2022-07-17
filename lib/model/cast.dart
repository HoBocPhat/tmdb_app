
import 'package:tmdb_app/api/decodable.dart';

class Cast implements Decodable<Cast>{
  Cast();
  late int id;
  String? profilePath;
  String? name;
  String? originalName;
  String? character;
  late String creditId;

  @override
  Cast decode (dynamic json){
    id = json['id'];
    profilePath = json['profile_path'];
    name = json['name'];
    originalName = json['original_name'];
    character = json['character'];
    creditId = json['credit_id'];
    return this;
  }
}