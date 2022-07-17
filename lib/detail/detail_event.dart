

part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object> get props => [];
}

class LoadTVDetail extends DetailEvent {
  int id;
  LoadTVDetail(this.id);
}

class LoadMovieDetail extends DetailEvent {
  int id;
  LoadMovieDetail(this.id);
}

class LoadCreditTV extends DetailEvent {
  int id;
  LoadCreditTV(this.id);
}

class LoadCreditMovie extends DetailEvent {
  int id;
  LoadCreditMovie(this.id);
}

class LoadKeywordTV extends DetailEvent {
  int id;
  LoadKeywordTV(this.id);
}

class LoadKeywordMovie extends DetailEvent {
  int id;
  LoadKeywordMovie(this.id);
}

class LoadTVRed extends DetailEvent {
  int id;
  LoadTVRed(this.id);
}

class LoadMovieRe extends DetailEvent {
  int id;
  LoadMovieRe(this.id);
}

class LoadTrailerTV extends DetailEvent {
  int id;
  LoadTrailerTV(this.id);
}

class LoadTrailerMovie extends DetailEvent {
  int id;
  LoadTrailerMovie(this.id);
}

