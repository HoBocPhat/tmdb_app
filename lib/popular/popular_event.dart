part of 'popular_bloc.dart';

abstract class PopularEvent extends Equatable {
  const PopularEvent();
  @override
  List<Object> get props => [];
}

class TVLoad extends PopularEvent {

}

class MovieLoad extends PopularEvent {

}

class TrendingDayLoad extends PopularEvent {

}
class TrendingWeekLoad extends PopularEvent {

}

class LoadMoreTV extends PopularEvent{
 final int page;
 const LoadMoreTV(this.page);
}

class LoadMoreMovie extends PopularEvent {
  final int page;
  const LoadMoreMovie(this.page);
}

class TrendingTodayTVLoad extends PopularEvent {

}

class TrendingTodayMovieLoad extends PopularEvent {

}

class TrendingWeekTVLoad extends PopularEvent {

}

class TrendingWeekMovieLoad extends PopularEvent {

}




