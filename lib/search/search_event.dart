part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object> get props => [];
}

class Searching extends SearchEvent {
  String keyword;
  Searching(this.keyword);
}

class SearchAll extends SearchEvent {
  String keyword;
  SearchAll(this.keyword);
}

class SearchMore extends SearchEvent {
  final String keyword;
  final int page;
  const SearchMore(this.page, this.keyword);
}