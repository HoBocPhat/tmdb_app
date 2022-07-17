import 'package:tmdb_app/api/decodable.dart';
import 'package:tmdb_app/model/person_response.dart';

import 'TV.dart';
import 'movie_demo.dart';

class SearchResponse implements Decodable<SearchResponse>{
  SearchResponse();
  late dynamic result;

  @override
  SearchResponse decode(dynamic json)
  {
      if(json['media_type'] == 'movie'){
        MovieDemo movie = MovieDemo().decode(json);
        result = movie;
      }
      else if(json['media_type'] == 'tv'){
        TV tv = TV().decode(json);
        result = tv;
      }
      else if(json['media_type'] == 'person'){
        PersonResponse person = PersonResponse().decode(json);
       result = person;
      }
    return this;

  }

}