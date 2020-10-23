import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum StepStatus {
  UNKNOWN,
  OK,
  CANCELED,
  PENDING,
}

class StepEntity extends Equatable {
  const StepEntity(this.name, this.status);

  final String name;
  final StepStatus status;

  @override
  List<Object> get props => [name, status];

  Map<String, Object> toJson() => {
        "name": name,
        "status": status,
      };

  @override
  String toString() => "StatusEntity { name: $name, owner: $status }";

  static StepEntity fromJson(Map<String, Object> json) => StepEntity(
        json["name"] as String,
        StepStatus.values[json["status"] as int],
      );

  static StepEntity fromSnapshot(DocumentSnapshot snapshot) => StepEntity(
        snapshot.id,
        StepStatus.values.length > (snapshot.get("status") as int)
            ? StepStatus.values[snapshot.get("status") as int]
            : StepStatus.UNKNOWN,
      );

  Map<String, Object> toDocument() => {
        "status": status.index,
      };
}
