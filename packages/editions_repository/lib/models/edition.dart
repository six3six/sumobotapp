import '../entities/edition_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Edition extends Equatable {
  const Edition({
    required this.uid,
    required this.name,
    this.date,
  });

  final String uid;
  final String name;
  final DateTime? date;

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
  List<Object?> get props => [uid, name, date];
}
