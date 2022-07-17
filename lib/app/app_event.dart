part of 'app_bloc.dart';

abstract class AppEvent extends Equatable{
  const AppEvent();

  @override
  List<Object> get props => [];
}

class RunApp extends AppEvent {

}

class Logout extends AppEvent {

}

class GetUser extends AppEvent {

}
