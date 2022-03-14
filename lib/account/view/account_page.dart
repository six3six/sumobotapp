import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/account/cubit/account_cubit.dart';
import 'package:sumobot/drawer/view/sumo_drawer.dart';

import 'account_view.dart';

class AccountPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SumoDrawer(),
      appBar: AppBar(
        title: const Text("Mon compte"),
      ),
      body: BlocProvider(
        create: (_) => AccountCubit(
          context.watch<AuthenticationRepository>(),
        ),
        child: AccountView(),
      ),
    );
  }
}
