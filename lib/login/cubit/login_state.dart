part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isSignIn = true,
    this.showSignInWithApple = false,
    this.name = const Name.dirty(""),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage = "",
  });

  final bool isSignIn;
  final bool showSignInWithApple;
  final Name name;
  final Email email;
  final Password password;
  final FormzStatus status;
  final String errorMessage;

  @override
  List<Object> get props => [
        isSignIn,
        name,
        email,
        password,
        status,
        showSignInWithApple,
        errorMessage,
      ];

  LoginState copyWith({
    bool? isSignIn,
    bool? showSignInWithApple,
    Name? name,
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      isSignIn: isSignIn ?? this.isSignIn,
      showSignInWithApple: showSignInWithApple ?? this.showSignInWithApple,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
