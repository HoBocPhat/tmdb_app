

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/auth/auth_repository.dart';
import 'package:tmdb_app/auth/form_submit_status.dart';
import 'package:tmdb_app/auth/login_event.dart';
import 'package:tmdb_app/auth/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;

  LoginBloc({required this.authRepo})
      : super(LoginState()) {
    on<LoginEvent>(_onEvent);
  }

  Future<void> _onEvent(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginUsernameChange) {
      emit(state.copyWith(formStatus: FormEditing(), username: event.username));
    }
    // password update
    else if (event is LoginPasswordChange) {
      emit(state.copyWith(formStatus: FormEditing(), password: event.password));
    }
    //form submitted
    if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        bool success = await authRepo.login(event.username,event.password);
        if(success == true){
          emit(state.copyWith(formStatus: SubmissionSuccess()));
        }


      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
      }
    }
    else if (event is LoginFingerPrint) {
      try{
        await authRepo.loginWithFinger();
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } catch (e){
        emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
      }
    }
    // else if (event is Logout) {
    //   await authRepo.logout();
    //   emit(state.logout(false));
    // }
  }
}
