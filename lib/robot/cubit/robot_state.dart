import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:robots_repository/models/robot.dart';
import 'package:robots_repository/models/step.dart';

class RobotState extends Equatable {
  const RobotState({
    this.robot = Robot.empty,
    required this.image,
    this.step = Step.empty,
  });

  final Robot robot;
  final Widget image;
  final Step step;

  RobotState copyWith({
    Robot? robot,
    Widget? image,
    step,
  }) {
    return RobotState(
      image: image ?? this.image,
      robot: robot ?? this.robot,
      step: step ?? this.step,
    );
  }

  @override
  List<Object> get props => [robot, image, step];
}
