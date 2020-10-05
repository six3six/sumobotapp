import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    final DocumentReference adminRef =
        FirebaseFirestore.instance.collection("roles").doc("admins");

    _userSubscription = _authenticationRepository.user.listen(
      (user) async {
        if (user == User.empty) {
          add(AuthenticationUserChanged(user, false));
        } else {
          final DocumentSnapshot adminSnapshot = await adminRef.get();
          bool isAdmin = false;
          try {
            adminSnapshot.get(user.id);
            isAdmin = true;
          } on StateError {
            isAdmin = false;
          }
          add(AuthenticationUserChanged(user, isAdmin));
        }
      },
    );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<User> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationRoleChanged) {
      yield _mapAuthenticationRoleChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) {
    return event.user != User.empty
        ? AuthenticationState.authenticated(event.user, event.isAdmin)
        : const AuthenticationState.unauthenticated();
  }

  AuthenticationState _mapAuthenticationRoleChangedToState(
    AuthenticationRoleChanged event,
  ) {
    return AuthenticationState.authenticated(this.state.user, event.isAdmin);
  }
}
