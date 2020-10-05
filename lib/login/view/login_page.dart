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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Colors.redAccent[700], Colors.red[700]])),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: double.infinity),
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
                        context.repository<AuthenticationRepository>(),
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
