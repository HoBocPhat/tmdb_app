part of 'detail_bloc.dart';

class DetailState extends Equatable{
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailTVLoading extends DetailState {

}

class DetailTVLoaded extends DetailState{
  TVDetailResponse tvDetailResponse;
  DetailTVLoaded(this.tvDetailResponse);
}

class DetailMovieLoading extends DetailState {

}

class DetailMovieLoaded extends DetailState{
  MovieDetailResponse movieDetailResponse;
  DetailMovieLoaded(this.movieDetailResponse);
}

class CreditLoading extends DetailState {

}

class CreditLoaded extends DetailState{
  List<Cast> cast;
  CreditLoaded(this.cast);
}

class KeywordLoading extends DetailState {

}

class TVKeywordLoaded extends DetailState{
  TVKeyword keyword;
  TVKeywordLoaded(this.keyword);
}

class MovieKeywordLoaded extends DetailState{
  MovieKeyword keyword;
  MovieKeywordLoaded(this.keyword);
}

class MovieReLoading extends DetailState{

}

class MovieReLoaded extends DetailState{
  List<MovieDemo> movie;
  MovieReLoaded(this.movie);
}
class TVReLoading extends DetailState{

}


class TVReLoaded extends DetailState{
  List<TV> tv;
  TVReLoaded(this.tv);
}

class TrailerMovieLoading extends DetailState{

}

class TrailerLoaded extends DetailState{
  Video video;
  TrailerLoaded(this.video);
}

class TrailerTVLoading extends DetailState{

}

class Error extends DetailState {
  final String err;
  const Error(this.err);
}


