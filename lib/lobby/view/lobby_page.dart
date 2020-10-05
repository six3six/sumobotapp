import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../lobby.dart';

class LobbyPage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyPage());
  }

  const LobbyPage({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LobbyCubit(),
      child: LobbyView(),
    );
  }
}