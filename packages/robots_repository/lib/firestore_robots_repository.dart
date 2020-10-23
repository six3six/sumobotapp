import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:editions_repository/editions_repository.dart';
import 'package:editions_repository/models/edition.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/robot_entity.dart';
import 'models/robot.dart';
import 'robots_repository.dart';

class FirestoreRobotsRepository extends RobotsRepository {
  CollectionReference robotCollection;
  final String edition;
  final AuthenticationRepository authenticationRepository;
  final EditionsRepository editionsRepository;

  FirestoreRobotsRepository(
      this.edition, this.authenticationRepository, this.editionsRepository) {
    robotCollection = FirebaseFirestore.instance
        .collection("editions")
        .doc(edition)
        .collection('robots');
  }

  @override
  Future<void> addNewRobot(Robot robot) async {
    DocumentReference document =
        await robotCollection.add(robot.toEntity().toDocument());
    print(document);
  }

  @override
  Future<void> deleteRobot(Robot robot) async {
    await robotCollection.doc(robot.uid).delete();
  }

  @override
  Stream<List<Robot>> robots({String search = "", User user}) {
    Query query = robotCollection.orderBy("name");
    if (user != null) query = query.where("owner", isEqualTo: user.id);
    query = query.where("name", isGreaterThanOrEqualTo: search);

    return _getRobotsFromQuery(query);
  }

  Stream<List<Robot>> _getRobotsFromQuery(Query query) async* {
    Edition edition = await editionsRepository.edition(this.edition).first;
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

    final StorageReference robotRef = FirebaseStorage.instance
        .ref()
        .child("robots")
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

    StorageMetadata metadata;
    try {
      metadata = await robotRef.getMetadata();
    } catch (e) {
      return imageLocal.path;
    }

    if (DateTime.fromMillisecondsSinceEpoch(metadata.updatedTimeMillis)
        .isAfter(lastMod)) {
      print("download $imageName");
      final StorageFileDownloadTask snap =
          await robotRef.writeToFile(imageLocal);
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
    File prevImage = File(imageDir.path + "/" + imageName);

    print(prevImage.path);

    if (!imageDir.existsSync()) imageDir.createSync();

    final StorageReference robotRef = FirebaseStorage.instance
        .ref().child("robots")
        .child(robot.owner.id)
        .child(robot.uid + ".jpg");

    final File newImage = File(image);
    if (!newImage.existsSync()) return prevImage.path;
    robotRef.putFile(newImage);

    if (prevImage.existsSync()) prevImage.delete();
    newImage.copySync(prevImage.path);

    return prevImage.path;
  }

  @override
  Stream<Robot> getRobotByUid(String robot) async* {
    Edition edition = await editionsRepository.edition(this.edition).first;
    await for (DocumentSnapshot snapshot
        in robotCollection.doc(robot).snapshots()) {
      final RobotEntity entity = RobotEntity.fromSnapshot(snapshot);
      yield await Robot.fromEntity(entity, edition, authenticationRepository);
    }
  }
}
