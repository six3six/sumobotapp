import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';

import 'models/robot.dart';
import 'robots_repository.dart';
import 'entities/robot_entity.dart';

class FirestoreRobotsRepository extends RobotsRepository {
  CollectionReference robotCollection;
  final Edition edition;

  FirestoreRobotsRepository(this.edition) {
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
    return robotCollection.snapshots().map((QuerySnapshot snapshot) => snapshot
        .docs
        .map((QueryDocumentSnapshot doc) =>
            Robot.fromEntity(RobotEntity.fromSnapshot(doc), edition))
        .toList());
  }

  @override
  Future<void> updateTodo(Robot robot) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }
}
