import 'package:tmdb_app/api/decodable.dart';

class Crew implements Decodable<Crew>{
  Crew();
  late int id;
  late String creditId;
  String? name;
  String? originalName;
  String? department;
  String? job;

  @override
  Crew decode(dynamic json){
    id = json['id'];
    creditId = json ['credit_id'];
    name = json['name'];
    originalName = json['original_name'];
    department = json['department'];
    job = json['job'];
    return this;
  }
}