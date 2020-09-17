import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sumobot/edition.dart';
import 'package:sumobot/profile.dart';
import 'package:sumobot/robot_admin.dart';

import 'login.dart';

class Lobby extends StatefulWidget {
  @override
  State<Lobby> createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  User user = FirebaseAuth.instance.currentUser;
  String userName = "";
  bool isAdmin = false;

  LobbyState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot document) => setState(() {
              userName = document.get("name");
              isAdmin = document.get("admin");
            }));

    OneSignal.shared.setEmail(email: user.email);
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.setExternalUserId(user.uid);
    OneSignal.shared.setSubscription(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(
            "Bonjour " + userName,
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
                icon: const Icon(Icons.thumb_up),
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
              isAdmin
                  ? LobbyButton(
                      text: "Administration",
                      icon: const Icon(Icons.settings),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RobotAdmin()),
                      ),
                    )
                  : Container(),
              Container(
                height: 20,
              ),
              LobbyButton(
                text: "Déconnexion",
                icon: const Icon(Icons.directions_run),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()));
                },
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
