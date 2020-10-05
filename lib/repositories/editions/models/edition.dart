import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sumobot/repositories/editions/entities/edition_entity.dart';

class Edition extends Equatable {
  const Edition({
    @required this.uid,
    @required this.name,
    @required this.date,
  })  : assert(uid != null),
        assert(name != null);

  final String uid;
  final String name;
  final DateTime date;

  static const empty = Edition(uid: '', name: '', date: null);

  EditionEntity toEntity() {
    return EditionEntity(uid, name, date);
  }

  static Edition fromEntity(EditionEntity entity) {
    return Edition(
      uid: entity.id,
      date: entity.date,
      name: entity.name,
    );
  }

  @override
  List<Object> get props => [this.uid, this.name, this.date];
}