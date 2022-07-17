import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/auth/auth_repository.dart';


part 'setting_event.dart';


part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthRepository authRepo;

  SettingBloc({required this.authRepo}) : super(const SettingState()) {
    on<SettingEvent>(_onEvent);
  }

  Future<void> _onEvent(SettingEvent event, Emitter<SettingState> emit) async {
    if(event is GetBiometric) {
      bool? _isBiometric;
      _isBiometric = await authRepo.getBiometric();
      if (_isBiometric == true) {
        emit(EnableFingerPrint());
      } else {
        emit(DisableFingerPrint());
      }
    }
    else if(event is ChangeFingerprint){
      if(event.value == true){
        authRepo.changeBiometric(event.value);
        emit(EnableFingerPrint());
      }
      else{
        authRepo.changeBiometric(event.value);
        emit(DisableFingerPrint());
      }
    }
  }
}