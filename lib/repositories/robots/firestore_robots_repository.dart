import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';

import 'models/robot.dart';
import 'robots_repository.dart';
import 'entities/robot_entity.dart';

class FirestoreRobotsRepository extends RobotsRepository {
  CollectionReference robotCollection;
  final Edition edition;
  final AuthenticationRepository authenticationRepository;

  FirestoreRobotsRepository(this.edition, this.authenticationRepository) {
    robotCollection = FirebaseFirestore.instance
        .collection("editions")
        .doc(edition.uid)
        .collection('robots');
  }

  @override
  Future<void> addNewRobot(Robot robot) {
    // TODO: implement addNewRobot
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRobot(Robot robot) {
    // TODO: implement deleteRobot
    throw UnimplementedError();
  }

  @override
  Stream<List<Robot>> robots() {
    return _getRobotsFromQuery(robotCollection.orderBy("name"));
  }

  @override
  Stream<List<Robot>> robotsSearch(String search) {
    return _getRobotsFromQuery(robotCollection
        .orderBy("name")
        .where("name", isGreaterThanOrEqualTo: search));
  }

  Stream<List<Robot>> _getRobotsFromQuery(Query query) async* {
    await for (QuerySnapshot querySnapshot in query.snapshots()) {
      List<Robot> robots = List<Robot>(querySnapshot.docs.length);

      int i = 0;
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        robots[i] = await Robot.fromEntity(
          RobotEntity.fromSnapshot(documentSnapshot),
          edition,
          authenticationRepository,
        );

        i++;
      }

      yield robots;
    }
  }

  @override
  Future<void> updateRobot(Robot robot) {
    // TODO: implement updateRobot
    throw UnimplementedError();
  }
}
