import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

import '../cubit/login_cubit.dart';

part 'login_theme.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_nameInput_textField'),
          style: fieldTheme,
          onChanged: (name) => context.read<LoginCubit>().nameChanged(name),
          keyboardType: TextInputType.text,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: '',
            errorText: state.name.invalid ? 'invalid name' : null,
          ).applyDefaults(loginInputDecorationTheme),
        );
      },
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          style: fieldTheme,
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Email',
            helperText: '',
            errorText: state.email.invalid ? 'invalid email' : null,
          ).applyDefaults(loginInputDecorationTheme),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          style: fieldTheme,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ).applyDefaults(loginInputDecorationTheme),
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  textColor: Colors.white,
                  child: const Text('SE CONNECTER'),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                ),
              );
      },
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton.icon(
        key: const Key('loginForm_googleLogin_raisedButton'),
        label: Text(
          'SE CONNECTER AVEC GOOGLE',
          style: TextStyle(color: theme.accentColor),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        icon: Icon(FontAwesomeIcons.google, color: theme.accentColor),
        color: Colors.white,
        onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
      ),
    );
  }
}

class AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton.icon(
        key: const Key('loginForm_appleLogin_raisedButton'),
        label: Text(
          'SE CONNECTER AVEC APPLE',
          style: TextStyle(color: Colors.white),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        icon: Icon(FontAwesomeIcons.apple, color: Colors.white),
        color: Colors.black,
        onPressed: () => context.read<LoginCubit>().logInWithApple(),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  key: const Key('loginForm_register_raisedButton'),
                  textColor: Colors.white,
                  child: const Text('CREER UN COMPTE'),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().signUpFormSubmitted()
                      : null,
                ),
              );
      },
    );
  }
}

class SignUpInButton extends StatelessWidget {
  final signin;

  const SignUpInButton({Key? key, @required this.signin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FlatButton(
      key: const Key('loginForm_createAccount_flatButton'),
      child: Text(
        signin ? 'CREER UN COMPTE' : 'SE CONNECTER',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => context.read<LoginCubit>().changeRequest(),
    );
  }
}
