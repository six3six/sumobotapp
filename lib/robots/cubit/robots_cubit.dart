import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';

import 'robots_state.dart';

class RobotsCubit extends Cubit<RobotsState> {
  RobotsCubit(this._robotsRepository, this._edition)
      : super(RobotsState(edition: _edition));

  final RobotsRepository _robotsRepository;
  final Edition _edition;

  StreamSubscription _subscription;

  void setSearchMode() {
    emit(state.copyWith(isSearching: true));
  }

  void setSearchModeToggle() {
    if(state.isSearching) setNormalMode();
    else setSearchMode();
  }

  void setNormalMode() {
    update();
    emit(state.copyWith(isSearching: false));
  }

  void setPersonal(bool isPersonal) {
    emit(state.copyWith(isPersonal: isPersonal));
  }

  void update() {
    _subscription?.cancel();
    _subscription = _robotsRepository.robots().listen((List<Robot> robots) {
      emit(state.copyWith(robots: robots));
    });
  }

  void search(String search) {
    _subscription?.cancel();
    _subscription = _robotsRepository.robotsSearch(search).listen((List<Robot> robots) {
      emit(state.copyWith(search: search, robots: robots));
    });
  }
}
