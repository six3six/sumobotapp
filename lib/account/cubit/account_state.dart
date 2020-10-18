import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:sumobot/authentication/models/models.dart';

class AccountState extends Equatable {
  const AccountState({
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  final Password password;
  final FormzStatus status;

  @override
  List<Object> get props => [password, status];

  AccountState copyWith({
    Password password,
    FormzStatus status,
  }) {
    return AccountState(
      status: status ?? this.status,
      password: password ?? this.password,
    );
  }
}
