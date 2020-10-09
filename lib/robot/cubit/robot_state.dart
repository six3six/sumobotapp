import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/models/step.dart';

class RobotState extends Equatable {
  const RobotState({
    this.robot = Robot.empty,
    @required this.image,
    this.step = Step.empty,
  })  : assert(robot != null),
        assert(image != null);

  final Robot robot;
  final Image image;
  final Step step;

  RobotState copyWith({
    Robot robot,
    Image image,
    Step step,
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
