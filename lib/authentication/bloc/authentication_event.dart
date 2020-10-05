part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user, this.isAdmin);

  final User user;
  final bool isAdmin;

  @override
  List<Object> get props => [user, isAdmin];
}

class AuthenticationRoleChanged extends AuthenticationEvent {
  const AuthenticationRoleChanged(this.isAdmin);

  final bool isAdmin;

  @override
  List<Object> get props => [isAdmin];
}


class AuthenticationLogoutRequested extends AuthenticationEvent {}