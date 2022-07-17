

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/model/TV.dart';
import 'package:tmdb_app/model/movie_demo.dart';
import 'package:tmdb_app/model/trending_response.dart';
import 'package:tmdb_app/model/tv_detail_response.dart';
import 'package:tmdb_app/repository/api_repository.dart';

import '../model/movie_detail_response.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final ApiRepository apiRepo;
  PopularBloc( {required this.apiRepo}) : super(const PopularState()) {
    on<PopularEvent>(_onEvent);
  }

  Future<void> _onEvent(PopularEvent event, Emitter<PopularState> emit) async {
    int pageMovie  = 1;
    int pageTV = 1;
    if(event is MovieLoad) {
      try {
        final movies = await apiRepo.fetchMoviePopular();
        emit(MovieLoaded(movies));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }
    else if(event is TVLoad) {
      try{
        final tv = await apiRepo.fetchTVPopular();
        emit(TVLoaded(tv));
      } catch (err) {
        emit(const PopularError("Can not get data"));
      }
    }
    if(event is TrendingDayLoad) {
      try {
        final tvs = await apiRepo.fetchTrendingDay();
        emit(TrendingDayLoaded(tvs));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }

    else if(event is TrendingWeekLoad) {
      try {
        final tvs = await apiRepo.fetchTrendingWeek();
        emit(TrendingWeekLoaded(tvs));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }
    if(event is LoadMoreTV) {
      emit(LoadingMore());
      int page = event.page + 1;
      try {
        final tv = await apiRepo.fetchMoreTV(page.toString());
        emit(LoadedTVMore(tv));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }
    else if(event is LoadMoreMovie) {
      emit(LoadingMore());
      int page = event.page + 1;
      try {
        final movie = await apiRepo.fetchMoreMovie(page.toString());
        emit(LoadedMovieMore(movie));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }

    if(event is TrendingTodayTVLoad) {
      emit(TrendingLoading());
      try {
        final tvs = await apiRepo.fetchTrendingTodayTV();
        emit(TrendingTVLoaded(tvs));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }

    else if(event is TrendingTodayMovieLoad) {
      emit(TrendingLoading());
      try {
        final movie = await apiRepo.fetchTrendingTodayMovie();
        emit(TrendingMovieLoaded(movie));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }

    else if(event is TrendingWeekTVLoad) {
      emit(TrendingLoading());
      try {
        final tvs = await apiRepo.fetchTrendingWeekTV();
        emit(TrendingTVLoaded(tvs));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }

    else if(event is TrendingWeekMovieLoad) {
      emit(TrendingLoading());
      try {
        final movie = await apiRepo.fetchTrendingWeekMovie();
        emit(TrendingMovieLoaded(movie));
      } catch (err){
        emit(const PopularError("Can not get data"));
      }
    }
  }
}
