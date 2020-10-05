import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';

import '../cubit/lobby_cubbit.dart';

class LobbyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
          _Card(
              text: "La compétition",
              icon: const Icon(Icons.thumb_up),
              onTap: () => null),
          const SizedBox(height: 10),
          _Card(
              text: "Mon compte",
              icon: const Icon(Icons.account_circle),
              onTap: () => null),
          const SizedBox(height: 10),
          _Card(
              text: "Déconnexion",
              icon: const Icon(Icons.directions_run),
              onTap: () => context
                  .bloc<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested())),
          const SizedBox(height: 10),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, AuthenticationState state) {
              return _Card(
                  text: "Scanner",
                  icon: const Icon(Icons.scanner),
                  onTap: () => null);
            },
          ),
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
            Container(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
