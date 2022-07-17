import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_app/api/api_client.dart';
import 'package:tmdb_app/auth/auth_repository.dart';
import 'package:tmdb_app/model/user.dart';

import 'package:tmdb_app/src/string.dart';
part 'app_event.dart';


part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepo;
  final APIClient apiClient;

  AppBloc( this.authRepo, this.apiClient) : super(Initial()) {
    on<AppEvent>(_onEvent);
  }

  Future<void> _onEvent(AppEvent event, Emitter<AppState> emit) async {
    final User user = User();

    if(event is RunApp){
      bool? isLogin = await authRepo.isLogin();
    if(isLogin == true){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user.username = prefs.getString(SHARED_USERNAME);

      bool success = await authRepo.loginWithToken(prefs.getString(SHARED_USERNAME), prefs.getString(SHARED_PASSWORD), prefs.getString(SHARED_TOKEN));
      if(success == true){
        emit(Logined(user));
      }
        else{
        await prefs.setBool(SHARED_LOGGED, false);
        emit(Logouted());
      }

    }
    else {
      emit(Logouted());
    }

  } else if(event is Logout){
      await authRepo.logout();
      emit(Logouted());
    }
    else if(event is GetUser){
      bool? isLogin = await authRepo.isLogin();
      if(isLogin == true){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user.username = prefs.getString(SHARED_USERNAME);
        emit(Logined(user));
    }
    }
  }
}