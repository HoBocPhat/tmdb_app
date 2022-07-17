

class Movie {
  String? backdropPath;

  late String releaseDate;


  late List<int> genreId;


  late int id;


  late String title;




  late String originalLanguage;


  late String originalTitle;


  late String overview;


  late double popularity;


  late String? posterPath;


  late double voteAverage;

  late int voteCount;

  late bool adult;

  late bool video;
  Movie.fromJson(Map<String, dynamic> json){
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
    voteAverage = (json['vote_average'] as num).toDouble();
    voteCount = json['vote_count'];
    adult = json['adult'];
    video = json['video'];

  }

  Map<String,dynamic> toJson () {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['backdrop_path'] = backdropPath;
    json['release_date'] = releaseDate;
    json['genre_ids'] = genreId;
    json['id'] = id;
    json['title'] = title;
    json['original_language'] = originalLanguage;
    json['overview'] =  overview;
    json['popularity'] = popularity;
    json['poster_path'] = posterPath;
    json['vote_average'] = voteAverage;
    json['vote_count'] = voteCount;
    json['adult'] = adult;
    json['video'] = video;
    return json;
  }
}
