import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          BlocBuilder<LobbyCubit, String>(
            builder: (context, state) {
              return Text(
                "Bonjour\r\n $state",
                style: textTheme.headline6,
                textAlign: TextAlign.left,
              );
            },
          ),
          Column(children: [
            Container(
              height: 20,
            ),
          ])
        ],
      ),
    );
  }
}

class LobbyButton extends StatelessWidget {
  LobbyButton({Key key, this.text, this.icon, this.onTap}) : super(key: key);

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
              title: new Text(text),
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
