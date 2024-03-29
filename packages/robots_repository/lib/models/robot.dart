import 'package:authentication_repository/authentication_repository.dart';
import 'package:editions_repository/models/edition.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../entities/robot_entity.dart';

class Robot extends Equatable {
  const Robot({
    required this.owner,
    required this.name,
    required this.uid,
    required this.edition,
  });

  final User owner;
  final String name;
  final String uid;
  final Edition edition;

  static const empty = Robot(
    uid: '',
    name: '',
    owner: User.empty,
    edition: Edition.empty,
  );

  static Future<Robot> fromEntity(RobotEntity entity, Edition edition,
      AuthenticationRepository authenticationRepository) async {
    return Robot(
      uid: entity.id,
      name: entity.name,
      owner: await authenticationRepository.getUserFromUid(entity.owner),
      edition: edition,
    );
  }

  RobotEntity toEntity() {
    return RobotEntity(uid, name, owner.id);
  }

  @override
  List<Object> get props => [owner, name, uid, edition];
}
