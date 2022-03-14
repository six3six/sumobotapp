import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/login/cubit/login_cubit.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Colors.redAccent[700] ?? Colors.redAccent,
              Colors.red[700] ?? Colors.red
            ],
          ),
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: double.infinity, maxWidth: 1000),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 700),
                padding: EdgeInsets.symmetric(horizontal: 30)
                    .add(EdgeInsets.only(top: 50)),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset("assets/sumobot_blanc.png"),
                    ),
                    BlocProvider(
                      create: (_) => LoginCubit(
                        context.watch<AuthenticationRepository>(),
                      ),
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
