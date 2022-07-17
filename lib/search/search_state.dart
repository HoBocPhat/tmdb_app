part of 'search_bloc.dart';

class SearchState extends Equatable{
  const SearchState();

  @override
  List<Object> get props => [];
}

class Searched extends SearchState {
  List<SearchResponse> result;
  Searched(this.result);
}

class SearchedAll extends SearchState{
  List<SearchResponse> result;
  SearchedAll(this.result);
}

class Waiting extends SearchState{

}

class SearchedMore extends SearchState {
  List<SearchResponse> result;
  SearchedMore(this.result);
}

class SearchError extends SearchState {
  String err;
  SearchError(this.err);
}