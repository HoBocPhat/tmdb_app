part of 'popular_bloc.dart';

class PopularState extends Equatable{
  const PopularState();

  @override
  List<Object> get props => [];
}

class valueChanged extends PopularState {
  final String value;
  const valueChanged(this.value);
}

class PopularInitial extends PopularState {

}

class TVLoading extends PopularState {
}

class TVLoaded extends PopularState {
  final List<TVDetailResponse> tvs;
  const TVLoaded(this.tvs);
}

class MovieLoading extends PopularState {
}

class MovieLoaded extends PopularState{
  final List<MovieDetailResponse> movies;
  const MovieLoaded(this.movies);
}

class PopularError extends PopularState {
  final String? message;
  const PopularError(this.message);
}

class TrendingDayLoading extends PopularState {
}
class TrendingDayLoaded extends PopularState {
  final List<TrendingResponse> list;
  const TrendingDayLoaded(this.list);
}

class TrendingWeekLoading extends PopularState{
}

class TrendingWeekLoaded extends PopularState {
  final List<TrendingResponse> list;
  const TrendingWeekLoaded(this.list);
}


class TrendingError extends PopularState {
  final String? message;
  const TrendingError(this.message);
}

class LoadedTVMore extends PopularState {
  final List<TVDetailResponse> listMore;
  const LoadedTVMore(this.listMore);
}

class LoadedMovieMore extends PopularState {
  final List<MovieDetailResponse> listMore;
  const LoadedMovieMore(this.listMore);
}

class LoadingMore extends PopularState {

}

class Searched extends PopularState {
  final List<dynamic> result;
  const Searched(this.result);
}

class TrendingTVLoaded extends PopularState {
  final List<TVDetailResponse> tvs;
  const TrendingTVLoaded(this.tvs);
}

class TrendingLoading extends PopularState {
}

class TrendingMovieLoaded extends PopularState{
  final List<MovieDetailResponse> movies;
  const TrendingMovieLoaded(this.movies);
}


