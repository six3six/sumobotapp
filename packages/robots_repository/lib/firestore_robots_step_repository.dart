import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robots_repository/robots_steps_repository.dart';

import 'entities/step_entity.dart';
import 'models/robot.dart';
import 'models/step.dart';

class FirestoreRobotsStepsRepository extends RobotsStepsRepository {
  FirestoreRobotsStepsRepository(this.edition) {
    robotCollection = FirebaseFirestore.instance
        .collection("editions")
        .doc(edition)
        .collection('robots');
  }

  CollectionReference robotCollection;
  String edition;

  @override
  Future<void> add(Robot robot, Step step) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(Robot robot, Step step) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Stream<Step> step(Robot robot) async* {
    final snapshot =
        robotCollection.doc(robot.uid).collection("step").snapshots();

    await for (final query in snapshot) {
      Step step = Step();
      for (final doc in query.docs) {
        step = step.changeStepFromEntity(StepEntity.fromSnapshot(doc));
      }
      yield step;
    }
  }

  @override
  Future<void> update(Robot robot, Step step) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
