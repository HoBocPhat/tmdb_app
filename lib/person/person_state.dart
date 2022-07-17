part of 'person_bloc.dart';

class PersonState extends Equatable{
  const PersonState();

  @override
  List<Object> get props => [];
}

class PersonLoading extends PersonState{

}

class PersonLoaded extends PersonState{
  PersonResponse person;
  PersonLoaded(this.person);
}

class Error extends PersonState{
  String err;
  Error(this.err);
}