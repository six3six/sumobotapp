import 'models/robot.dart';

abstract class RobotsRepository {
  Future<void> addNewRobot(Robot robot);

  Future<void> deleteRobot(Robot robot);

  Stream<List<Robot>> robots();

  Stream<List<Robot>> robotsSearch(String search);

  Future<void> updateRobot(Robot robot);
}
