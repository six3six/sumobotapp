import 'models/robot.dart';

abstract class RobotsRepository {
  Future<void> addNewRobot(Robot robot);

  Future<void> deleteRobot(Robot robot);

  Stream<List<Robot>> robots();

  Future<void> updateTodo(Robot robot);
}
