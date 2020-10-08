import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';

import 'robots_state.dart';

class RobotsCubit extends Cubit<RobotsState> {
  RobotsCubit(this._robotsRepository) : super(const RobotsState());

  final RobotsRepository _robotsRepository;

  void setSearchMode() {
    emit(state.copyWith(isSearching: true));
  }
  void setSearchModeToggle() {
    print(state.copyWith(isSearching: !state.isSearching).isSearching);
    emit(state.copyWith(isSearching: !state.isSearching));
  }

  void setNormalMode() {
    emit(state.copyWith(isSearching: false));
  }

}
