import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/account/cubit/account_cubit.dart';
import 'package:sumobot/account/cubit/account_state.dart';
import 'package:formz/formz.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';

import 'account_widgets.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: <Widget>[
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(state.user.photo ?? ""),
                  radius: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    "${state.user.name}",
                    style: textTheme.headline5,
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            );
          }),
          const SizedBox(height: 60.0),
          Text("Changer mon mot de passe", style: textTheme.headline6),
          PasswordInput(),
          const SizedBox(height: 20),
          ChangePasswordButton(),
        ],
      ),
    );
  }
}
