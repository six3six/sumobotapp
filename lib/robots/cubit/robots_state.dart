import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';

class RobotsState extends Equatable {
  final List<Robot> robots;
  final bool isSearching;

  const RobotsState({
    this.robots = const <Robot>[],
    this.isSearching = false,
  });

  RobotsState copyWith({
    bool isSearching,
    List<Robot> robots,
  }) {
    print(isSearching);
    return RobotsState(
      isSearching: isSearching ?? this.isSearching,
      robots: robots ?? this.robots,
    );
  }

  @override
  List<Object> get props => [robots, isSearching];
}
