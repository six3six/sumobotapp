import 'package:authentication_repository/authentication_repository.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/account/view/account_page.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/drawer/view/sumo_drawer.dart';
import 'package:sumobot/editions/views/editions_page.dart';
import 'package:sumobot/map/view/map_page.dart';
import 'package:sumobot/robot/view/robot_page.dart';

class LobbyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyPage());
  }

  const LobbyPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: SumoDrawer(),
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return Text(
                "Bonjour\r\n${state.user.name}",
                style: textTheme.headline6,
                textAlign: TextAlign.left,
              );
            },
          ),
          const SizedBox(height: 30),

        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  _Card({Key key, this.text, this.icon, this.onTap}) : super(key: key);

  final String text;
  final Icon icon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: icon,
              title: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
