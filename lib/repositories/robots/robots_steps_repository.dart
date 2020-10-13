
import 'models/robot.dart';
import 'models/step.dart';

abstract class RobotsStepsRepository {
  RobotsStepsRepository();

  Future<void> add(Robot robot, Step step);

  Future<void> delete(Robot robot, Step step);

  Future<void> update(Robot robot, Step step);

  Stream<Step> step(Robot robot);
}
