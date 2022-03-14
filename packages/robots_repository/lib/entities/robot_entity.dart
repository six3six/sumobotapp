import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RobotEntity extends Equatable {
  const RobotEntity(this.id, this.name, this.owner);

  final String id;
  final String name;
  final String owner;

  @override
  List<Object> get props => [id, name, owner];

  Map<String, Object> toJson() => {
        "id": id,
        "name": name,
        "owner": owner,
      };

  @override
  String toString() => "RobotEntity { name: $name, owner: $owner }";

  static RobotEntity fromJson(Map<String, Object> json) => RobotEntity(
        json["id"] as String,
        json["name"] as String,
        json["owner"] as String,
      );

  static RobotEntity fromSnapshot(DocumentSnapshot snapshot) => RobotEntity(
        snapshot.id,
        snapshot.get("name") as String? ?? "",
        snapshot.get("owner") as String? ?? "",
      );

  Map<String, Object> toDocument() => {
        "name": name,
        "owner": owner,
      };
}
