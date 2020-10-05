import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sumobot/login/cubit/login_cubit.dart';

import 'login_widgets.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key key}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Column(children: <Widget>[
        const SizedBox(height: 60.0),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) =>
              previous.isSignIn != current.isSignIn,
          builder: (context, LoginState state) {
            if (!state.isSignIn) {
              return Column(
                children: [
                  NameInput(),
                  SizedBox(height: 30),
                ],
              );
            }
            return SizedBox(height: 1);
          },
        ),
        EmailInput(),
        const SizedBox(height: 30),
        PasswordInput(),
        const SizedBox(height: 70),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) =>
              previous.isSignIn != current.isSignIn,
          builder: (context, LoginState state) {
            return state.isSignIn ? LoginButton() : SignUpButton();
          },
        ),
        const SizedBox(height: 30),
        GoogleLoginButton(),
        const SizedBox(height: 70),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) =>
              previous.isSignIn != current.isSignIn,
          builder: (context, LoginState state) {
            return SignUpInButton(
              signin: state.isSignIn,
            );
          },
        ),
        const SizedBox(height: 70),
      ]),
    );
  }
}
