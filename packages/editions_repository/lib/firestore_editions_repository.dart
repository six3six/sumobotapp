import 'package:cloud_firestore/cloud_firestore.dart';

import 'editions_repository.dart';
import 'entities/edition_entity.dart';
import 'models/edition.dart';


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

  @override
  Stream<Edition> edition(String uid) {
    return editionCollection.doc(uid).get().asStream().map(
        (DocumentSnapshot snapshot) =>
            Edition.fromEntity(EditionEntity.fromSnapshot(snapshot)));
  }
}
