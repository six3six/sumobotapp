import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import '../entities/robot_entity.dart';

class Robot extends Equatable {
  const Robot({
    @required this.owner,
    @required this.name,
    @required this.uid,
    @required this.edition,
  })  : assert(uid != null),
        assert(name != null),
        assert(owner != null);

  final String owner;
  final String name;
  final String uid;
  final Edition edition;

  static const empty = Robot(
    uid: '',
    name: '',
    owner: '',
    edition: Edition.empty,
  );


  static Robot fromEntity(RobotEntity entity, Edition edition) {
    return Robot(
      uid: entity.id,
      name: entity.name,
      owner: entity.owner,
      edition: edition,
    );
  }

  @override
  List<Object> get props => [owner, name, uid, edition];
}
