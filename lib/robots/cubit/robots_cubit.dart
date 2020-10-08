import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';

import 'robots_state.dart';

class RobotsCubit extends Cubit<RobotsState> {
  RobotsCubit(this._robotsRepository, this._edition) : super(RobotsState(edition: _edition));

  final RobotsRepository _robotsRepository;
  final Edition _edition;

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

  void update() async {
    emit(state.resetRobots());
    _robotsRepository.robots().listen((List<Robot> robots) {
      emit(state.addRobots(robots));
    });
  }

}
