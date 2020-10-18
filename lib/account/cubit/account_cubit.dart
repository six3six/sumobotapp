import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sumobot/account/cubit/account_state.dart';
import 'package:sumobot/authentication/models/password.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._authenticationRepository) : super(AccountState());

  final AuthenticationRepository _authenticationRepository;

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password]),
    ));
  }

  void changePassword() {
    _authenticationRepository.changePassword(state.password.value);
  }
}
