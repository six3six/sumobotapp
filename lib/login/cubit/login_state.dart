part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isSignIn = true,
    this.name = const Name.dirty(""),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  final bool isSignIn;
  final Name name;
  final Email email;
  final Password password;
  final FormzStatus status;

  @override
  List<Object> get props => [isSignIn, name, email, password, status];

  LoginState copyWith({
    bool isSignIn,
    Name name,
    Email email,
    Password password,
    FormzStatus status,
  }) {
    return LoginState(
      isSignIn: isSignIn ?? this.isSignIn,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}