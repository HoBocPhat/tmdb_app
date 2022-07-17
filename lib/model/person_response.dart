
import 'package:tmdb_app/api/decodable.dart';

class PersonResponse implements Decodable<PersonResponse>{
  late int id;
  late bool adult;
  String? profilePath;
  String? name;
  String? knownFor;
  String? gender;
  String? birthday;
  String? deathday;
  String? birthPlace;
  String? biography;
  int? age;

  PersonResponse();

  @override
  PersonResponse decode(dynamic json){
    id = json['id'];
    adult = json['adult'];
    profilePath = json['profile_path'];
    name = json['name'];
    knownFor = json['known_for_department'];
    int g = json['gender'];
    if(g == 1){
      gender = 'Female';
    }
    else if(g == 2){
      gender = 'Male';
    }
    birthday = json['birthday'];
    List<String> dates = birthday!=null? birthday!.split('-'): [];
    int year = dates.isNotEmpty ? int.parse(dates[0]): 0;
    DateTime currentDate = DateTime.now();
    age = currentDate.year - year;
    deathday = json['deathday'];
    birthPlace = json['place_of_birth'];
    biography = json['biography'];
    return this;
  }
}