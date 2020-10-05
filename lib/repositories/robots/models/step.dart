import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Step extends Equatable {
  const Step({
    @required this.isPayed,
    @required this.isValidate,
    @required this.isRegistered,
  })  : assert(isPayed != null),
        assert(isValidate != null),
        assert(isRegistered != null);

  final bool isPayed;
  final bool isValidate;
  final bool isRegistered;

  static const empty =
      Step(isValidate: false, isPayed: false, isRegistered: false);

  @override
  List<Object> get props => [isPayed, isValidate, isRegistered];
}
