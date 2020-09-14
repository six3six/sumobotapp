import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sumobot/edition.dart';
import 'package:sumobot/profile.dart';
import 'package:sumobot/robot_admin.dart';

import 'login.dart';

class Lobby extends StatelessWidget {
  Lobby({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(
            "Bonjour " + user?.displayName,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.left,
          ),
          Column(
            children: [
              Container(
                height: 20,
              ),
              LobbyButton(
                text: "La compétition",
                icon: Icon(Icons.thumb_up),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Edition()),
                ),
              ),
              Container(
                height: 20,
              ),
              LobbyButton(
                text: "Mon compte",
                icon: Icon(Icons.account_circle),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                ),
              ),
              Container(
                height: 20,
              ),
              LobbyButton(
                text: "Déconnection",
                icon: Icon(Icons.directions_run),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
              Container(
                height: 20,
              ),
              LobbyButton(
                text: "Administration",
                icon: Icon(Icons.settings),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RobotAdmin()),
                ),
              ),
            ],
          )
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
