import 'package:editions_repository/editions_repository.dart';
import 'package:editions_repository/models/edition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'editions_state.dart';

class EditionsCubit extends Cubit<EditionsState> {
  EditionsCubit(this._editionsRepository) : super(const EditionsState());

  final EditionsRepository _editionsRepository;

  Future<void> update() async {
    _editionsRepository.editions().listen((List<Edition> editions) {
      emit(EditionsState(editions: editions));
    });
  }
}
