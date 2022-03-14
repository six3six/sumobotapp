import 'package:editions_repository/models/edition.dart';
import 'package:equatable/equatable.dart';
import 'package:robots_repository/models/robot.dart';

class RobotsState extends Equatable {
  final List<Robot> robots;
  final bool isSearching;
  final Edition edition;
  final String search;
  final bool isPersonal;
  final bool isLoading;

  const RobotsState({
    this.robots = const <Robot>[],
    this.isSearching = false,
    this.edition = Edition.empty,
    this.search = "",
    this.isPersonal = false,
    this.isLoading = true,
  });

  RobotsState resetRobots() {
    return copyWith(robots: const <Robot>[]);
  }

  RobotsState addRobot(Robot edition) {
    List<Robot> tmpEditions = const [];
    tmpEditions.addAll(robots);
    tmpEditions.add(edition);
    return copyWith(robots: tmpEditions);
  }

  RobotsState addRobots(List<Robot> editions) {
    List<Robot> tmpEditions = const [];
    tmpEditions.addAll(this.robots);
    tmpEditions.addAll(editions);
    return copyWith(robots: tmpEditions);
  }

  RobotsState copyWith({
    bool? isSearching,
    List<Robot>? robots,
    Edition? edition,
    String? search,
    bool? isPersonal,
    bool? isLoading,
  }) {
    return RobotsState(
      isSearching: isSearching ?? this.isSearching,
      robots: robots ?? this.robots,
      edition: edition ?? this.edition,
      search: search ?? this.search,
      isPersonal: isPersonal ?? this.isPersonal,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props =>
      [robots, isSearching, search, isPersonal, isLoading];
}
