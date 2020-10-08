import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';

class RobotsState extends Equatable {
  final List<Robot> robots;
  final bool isSearching;
  final Edition edition;
  final String search;

  const RobotsState({
    this.robots = const <Robot>[],
    this.isSearching = false,
    this.edition = Edition.empty,
    this.search = "",
  });

  RobotsState resetRobots() {
    return copyWith(robots: const <Robot>[]);
  }

  RobotsState addRobot(Robot edition) {
    List<Robot> tmpEditions = List<Robot>();
    tmpEditions.addAll(robots);
    tmpEditions.add(edition);
    return copyWith(robots: tmpEditions);
  }

  RobotsState addRobots(List<Robot> editions) {
    List<Robot> tmpEditions = List<Robot>();
    tmpEditions.addAll(this.robots);
    tmpEditions.addAll(editions);
    return copyWith(robots: tmpEditions);
  }

  RobotsState copyWith({
    bool isSearching,
    List<Robot> robots,
    Edition edition,
    String search,
  }) {
    return RobotsState(
      isSearching: isSearching ?? this.isSearching,
      robots: robots ?? this.robots,
      edition: edition ?? this.edition,
      search: search ?? this.search,
    );
  }

  @override
  List<Object> get props => [robots, isSearching, search, edition];
}
