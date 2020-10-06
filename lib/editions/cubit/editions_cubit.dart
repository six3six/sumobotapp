import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/editions_repository.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';

import 'editions_state.dart';

class EditionsCubit extends Cubit<EditionsState> {
  EditionsCubit(this._editionsRepository) : super(const EditionsState());

  final EditionsRepository _editionsRepository;

  Future<void> update() async {
    emit(state.resetEditions());
    _editionsRepository.editions().listen((List<Edition> editions) {
      emit(state.addEditions(editions));
    });
  }
}
