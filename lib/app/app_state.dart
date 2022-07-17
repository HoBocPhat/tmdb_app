part of 'app_bloc.dart';

abstract class AppState extends Equatable{
  const AppState();

  @override
  List<Object> get props => [];
}

class Logined extends AppState {
  User? user;
  Logined(this.user);

}

class Logouted extends AppState {

}

class Initial extends AppState {

}