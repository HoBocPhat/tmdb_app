

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/api/api_route.dart';

import 'package:tmdb_app/model/keyword_response.dart';
import 'package:tmdb_app/model/movie_detail_response.dart';
import 'package:tmdb_app/model/tv_detail_response.dart';
import 'package:tmdb_app/model/video_response.dart';
import 'package:tmdb_app/repository/api_repository.dart';

import '../model/TV.dart';
import '../model/cast.dart';
import '../model/movie_demo.dart';


part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final ApiRepository apiRepo;

  DetailBloc({required this.apiRepo}) : super(const DetailState()) {
    on<DetailEvent>(_onEvent);
  }

  Future<void> _onEvent(DetailEvent event, Emitter<DetailState> emit) async {
    if (event is LoadTVDetail) {
      emit(DetailTVLoading());
      TVDetailResponse tv = await apiRepo.fetchDetailTV(event.id);
      emit(DetailTVLoaded(tv));
    }

    else if (event is LoadMovieDetail) {
      emit(DetailMovieLoading());
      try{
      MovieDetailResponse movie = await apiRepo.fetchDetailMovie(event.id);
      emit(DetailMovieLoaded(movie));
      } catch (err){
        emit(const Error("Can not get data"));
      }
    }

    if(event is LoadCreditTV){
      emit(CreditLoading());
      final cast = await apiRepo.fetchCast(event.id, APIType.castTV);
      emit(CreditLoaded(cast));
    }

    else if( event is LoadCreditMovie){
      emit(CreditLoading());
      final cast = await apiRepo.fetchCast(event.id, APIType.castMovie);
      emit(CreditLoaded(cast));
    }

    if(event is LoadTVRed){
      emit(TVReLoading());
      List<TV> tv = await apiRepo.fetchRecommendTV(event.id);
      emit(TVReLoaded(tv));
    }

    else if(event is LoadMovieRe){
      emit(MovieReLoading());
      List<MovieDemo> movie = await apiRepo.fetchRecommendMovie(event.id);
      emit(MovieReLoaded(movie));
    }

    if(event is LoadTrailerTV){
      emit(TrailerTVLoading());
      final video = await apiRepo.fetchTrailer(event.id, APIType.trailerTV);
      emit(TrailerLoaded(video));
    }

    else if(event is LoadTrailerMovie){
      emit(TrailerMovieLoading());
      final video = await apiRepo.fetchTrailer(event.id, APIType.trailerMovie);
      emit(TrailerLoaded(video));
    }

  }
}