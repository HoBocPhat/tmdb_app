import 'package:tmdb_app/api/decodable.dart';

import 'TV.dart';
import 'movie_demo.dart';

class TrendingResponse implements Decodable<TrendingResponse>{
  TrendingResponse();
  late dynamic result;

  @override
  TrendingResponse decode(dynamic json)
  {
    if(json['media_type'] == 'movie'){
      MovieDemo movie = MovieDemo().decode(json);
      result = movie;
    }
    else if(json['media_type'] == 'tv'){
      TV tv = TV().decode(json);
      result = tv;
    }
    return this;

  }

}