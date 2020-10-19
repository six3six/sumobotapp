import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sumobot/account/view/account_page.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/editions/views/editions_page.dart';
import 'package:sumobot/news/view/news_page.dart';
import 'package:sumobot/map/view/map_page.dart';
import 'package:sumobot/robot/view/robot_page.dart';

class SumoDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset("assets/sumobot.png"),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(state.user.photo),
                          radius: 35,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "${state.user.name}",
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          _DrawerTile(
            name: "Actualités",
            icon: const Icon(FontAwesomeIcons.newspaper),
            onTap: () => Navigator.push(context, NewsPage.route()),
          ),
          _DrawerTile(
            name: "Editions",
            icon: const Icon(Icons.apps),
            onTap: () => Navigator.push(context, EditionsPage.route()),
          ),
          _DrawerTile(
            name: "Carte",
            icon: const Icon(Icons.map),
            onTap: () => Navigator.push(context, MapPage.route()),
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, AuthenticationState state) {
              return state.user.admin
                  ? _DrawerTile(
                      name: "Scanner",
                      icon: const Icon(Icons.scanner),
                      onTap: () async {
                        var result = await BarcodeScanner.scan();
                        List<String> data = result.rawContent.split(";");
                        if (data.length != 3 || data[0] != "SUMOCODE")
                          return Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Ceci n'est pas un code SUMOBOT"),
                          ));
                        final route = RobotPage.route(
                          data[1],
                          data[2],
                        );
                        Navigator.of(context).push(route);
                      },
                    )
                  : const SizedBox();
            },
          ),
          const Divider(),
          _DrawerTile(
            name: "Mon compte",
            icon: const Icon(Icons.account_circle),
            onTap: () => Navigator.push(context, AccountPage.route()),
          ),
          _DrawerTile(
            name: "Déconnexion",
            icon: const Icon(Icons.directions_run),
            onTap: () => context
                .bloc<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final String name;
  final Icon icon;
  final GestureTapCallback onTap;

  const _DrawerTile(
      {Key key, @required this.name, @required this.icon, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(name),
      onTap: onTap,
    );
  }
}
