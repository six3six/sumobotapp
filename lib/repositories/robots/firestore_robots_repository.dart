import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
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
  Future<void> addNewRobot(Robot robot) async {
    DocumentReference document =
        await robotCollection.add(robot.toEntity().toDocument());
    print(document);
  }

  @override
  Future<void> deleteRobot(Robot robot) {
    // TODO: implement deleteRobot
    throw UnimplementedError();
  }

  @override
  Stream<List<Robot>> robots({String search = "", User user}) {
    Query query = robotCollection.orderBy("name");
    if (user != null) query = query.where("owner", isEqualTo: user.id);
    query = query.where("name", isGreaterThanOrEqualTo: search);

    return _getRobotsFromQuery(query);
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

  @override
  Future<String> getImage(Robot robot) async {
    final String imageName = robot.uid + ".jpg";

    final Reference robotRef = FirebaseStorage.instance
        .ref("robots")
        .child(robot.owner.id)
        .child(imageName);

    final Directory dataDir = await getApplicationDocumentsDirectory();
    if (!dataDir.existsSync()) {
      dataDir.createSync();
      dataDir.createTempSync();
    }

    final Directory imageDir = Directory(dataDir.path + "/robotImage");
    if (!imageDir.existsSync()) imageDir.createSync();

    final File imageLocal = File(imageDir.path + "/" + imageName);
    final DateTime lastMod = imageLocal.existsSync()
        ? imageLocal.lastModifiedSync()
        : DateTime.fromMicrosecondsSinceEpoch(0);

    FullMetadata metadata;
    try {
      metadata = await robotRef.getMetadata();
    } catch (e) {
      return imageLocal.path;
    }


    if (metadata.updated.isAfter(lastMod)) {
      print("download $imageName");
      final TaskSnapshot snap = await robotRef.writeToFile(imageLocal);
    }

    return imageLocal.path;
  }

  @override
  Future<String> setImage(Robot robot, String image) async {
    final String imageName = robot.uid + ".jpg";


    final Directory dataDir = await getApplicationDocumentsDirectory();
    if (!dataDir.existsSync()) {
      dataDir.createSync();
      dataDir.createTempSync();
    }
    final Directory imageDir = Directory(dataDir.path + "/robotImage");
    final String imagePath = imageDir.path + "/" + imageName;

    if (!imageDir.existsSync()) imageDir.createSync();

    final Reference robotRef = FirebaseStorage.instance
        .ref("robots")
        .child(robot.owner.id)
        .child(robot.uid + ".jpg");

    final File newImage = File(image);
    if (!newImage.existsSync()) return imagePath;
    await robotRef.putFile(newImage);

    newImage.copySync(imagePath);

    return imagePath;
  }
}
