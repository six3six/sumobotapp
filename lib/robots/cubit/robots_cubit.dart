import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';

import 'robots_state.dart';

class RobotsCubit extends Cubit<RobotsState> {
  RobotsCubit(this._robotsRepository, Edition _edition, this._user)
      : assert(_robotsRepository != null),
        super(RobotsState(edition: _edition, isLoading: true));

  final RobotsRepository _robotsRepository;
  final User _user;

  StreamSubscription _subscription;

  void setSearchMode() {
    emit(state.copyWith(isSearching: true));
  }

  void setSearchModeToggle() {
    if (state.isSearching)
      setNormalMode();
    else
      setSearchMode();
  }

  void setNormalMode() {
    update();
    emit(state.copyWith(isSearching: false));
  }

  void setPersonal(bool isPersonal) {
    emit(state.copyWith(isPersonal: isPersonal, isLoading: true));
    if (state.isSearching)
      search(state.search);
    else
      update();
  }

  void update() {
    emit(state.copyWith(isLoading: true));

    _subscription?.cancel();
    _subscription = _robotsRepository
        .robots(user: state.isPersonal ? _user : null)
        .listen((List<Robot> robots) {
      emit(state.copyWith(robots: robots, isLoading: false));
    });
  }

  void search(String search) {
    emit(state.copyWith(isLoading: true));

    _subscription?.cancel();
    _subscription = _robotsRepository
        .robots(search: search, user: state.isPersonal ? _user : null)
        .listen((List<Robot> robots) {
      emit(state.copyWith(search: search, robots: robots, isLoading: false));
    });
  }
}
