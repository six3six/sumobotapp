import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sumobot/repositories/editions/editions_repository.dart';
import 'package:sumobot/repositories/editions/entities/edition_entity.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';

class FirestoreEditionsRepository extends EditionsRepository {
  final editionCollection = FirebaseFirestore.instance.collection('editions');

  @override
  Stream<List<Edition>> editions() {
    return editionCollection.snapshots().map((QuerySnapshot snapshot) =>
        snapshot.docs
            .map((QueryDocumentSnapshot doc) =>
                Edition.fromEntity(EditionEntity.fromSnapshot(doc)))
            .toList());
  }
}
