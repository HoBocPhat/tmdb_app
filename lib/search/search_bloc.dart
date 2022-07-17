
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/model/search_response.dart';

import '../repository/api_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiRepository apiRepo;

  SearchBloc({required this.apiRepo}) : super(const SearchState()) {
    on<SearchEvent>(_onEvent);
  }

  Future<void> _onEvent(SearchEvent event, Emitter<SearchState> emit) async {
    if(event is Searching){
      emit(Waiting());
      try {
        final List<SearchResponse> result = await apiRepo.fetchSearchResult(event.keyword, page: "1");
        emit(Searched(result));
      } catch (err){
        emit(SearchError("Can not get data"));
      }
    }
    else if (event is SearchAll){
      emit(Waiting());
      try {
        final List<SearchResponse> result = await apiRepo.fetchSearchResult(event.keyword);
        emit(SearchedAll(result));
      } catch (err){
        emit(SearchError("Can not get data"));
      }
    }

    if(event is SearchMore){
      emit(Waiting());
      int page = event.page + 1;
      try {
        final List<SearchResponse> result = await apiRepo.fetchSearchResult(event.keyword, page: page.toString());
        emit(SearchedMore(result));
      } catch (err){
        emit(SearchError("Can not get data"));
      }
    }

  }
}