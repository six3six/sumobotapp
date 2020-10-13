import 'package:authentication_repository/authentication_repository.dart';

import 'models/robot.dart';

abstract class RobotsRepository {
  Future<void> addNewRobot(Robot robot);

  Future<void> deleteRobot(Robot robot);

  Stream<List<Robot>> robots({String search, User user});

  Future<void> updateRobot(Robot robot);

  Future<String> getImage(Robot robot);

  Future<String> setImage(Robot robot, String image);
}
