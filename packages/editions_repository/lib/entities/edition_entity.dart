import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EditionEntity extends Equatable {
  const EditionEntity(this.id, this.name, this.date);

  final String id;
  final String name;
  final DateTime date;

  @override
  List<Object> get props => [id, name, date];

  Map<String, Object> toJson() => {
        "id": id,
        "name": name,
        "status": date,
      };

  @override
  String toString() => "StatusEntity { id: $id, name: $name, owner: $date }";

  static EditionEntity fromJson(Map<String, Object> json) => EditionEntity(
        json["id"] as String,
        json["name"] as String,
        DateTime.parse(json["date"]),
      );

  static EditionEntity fromSnapshot(DocumentSnapshot snapshot) => EditionEntity(
        snapshot.id,
        snapshot.get("name") as String,
        (snapshot.get("date") as Timestamp).toDate(),
      );

  Map<String, Object> toDocument() => {
        "name": name,
        "date": date,
      };
}
