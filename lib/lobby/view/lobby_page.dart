import 'package:authentication_repository/authentication_repository.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/editions/views/editions_page.dart';
import 'package:sumobot/robot/view/robot_page.dart';

class LobbyPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LobbyPage());
  }

  const LobbyPage({Key key}) : super(key: key);

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
              onTap: () =>
                  Navigator.of(context).push<void>(EditionsPage.route())),
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
              return state.user.admin
                  ? _Card(
                      text: "Scanner",
                      icon: const Icon(Icons.scanner),
                      onTap: () async {
                        var result = await BarcodeScanner.scan();
                        List<String> data = result.rawContent.split(";");
                        if (data.length != 2) return;
                        final route = RobotPage.route(
                          data[0],
                          data[1],
                        );
                        Navigator.of(context).push(route);
                      },
                    )
                  : const SizedBox();
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
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
