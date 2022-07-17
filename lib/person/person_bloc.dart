import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/model/person_response.dart';

import '../repository/api_repository.dart';

part 'person_event.dart';
part 'person_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final ApiRepository apiRepo;
  PersonBloc({required this.apiRepo}) : super(const PersonState()) {
    on<PersonEvent>(_onEvent);
  }

  Future<void> _onEvent(PersonEvent event, Emitter<PersonState> emit) async {
    if (event is LoadPerson) {
      emit(PersonLoading());
      try {
        final person = await apiRepo.fetchPersonDetail(event.id);
        emit(PersonLoaded(person));
      } catch (err) {
        emit(Error("Can not get data"));
      }
    }
  }
}
