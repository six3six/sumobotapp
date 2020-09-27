import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sumobot/edition.dart';
import 'package:sumobot/profile.dart';
import 'package:sumobot/robot.dart';

import 'login.dart';

class Lobby extends StatefulWidget {
  @override
  State<Lobby> createState() => LobbyState();
}

class LobbyState extends State<Lobby> {
  User user = FirebaseAuth.instance.currentUser;
  String userName = "";
  bool admin = false;

  String error;

  LobbyState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot document) => setState(() {
              userName = document.get("name");
            }))
        .catchError((error) => setState(() => this.error += error + "\r"));

    FirebaseFirestore.instance
        .collection("roles")
        .doc("admins")
        .snapshots()
        .forEach((element) async {
      admin = await isAdmin(user.uid);
      setState(() {
        print("update");
      });
    });

    OneSignal.shared.setExternalUserId(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = List<Widget>();
    tiles.addAll(
      makeTile(
        "La compétition",
        const Icon(Icons.thumb_up),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Edition()),
        ),
      ),
    );

    tiles.addAll(
      makeTile(
        "Mon compte",
        const Icon(Icons.account_circle),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        ),
      ),
    );

    if (this.admin) {
      tiles.addAll(
        makeTile(
          "Scanner",
          const Icon(Icons.qr_code_scanner),
          () async {
            var result = await BarcodeScanner.scan();
            List<String> data = result.rawContent.split(";");
            if (data.length != 2) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Robot(
                  edition: data[0],
                  robotId: data[1],
                ),
              ),
            );
          },
        ),
      );
    }

    tiles.addAll(
      makeTile(
        "Déconnexion",
        const Icon(Icons.directions_run),
        () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()));
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(
            "Bonjour\r\n" + userName,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.left,
          ),
          Column(
            children: [
              Container(
                height: 20,
              ),
            ]..addAll(tiles),
          )
        ],
      ),
    );
  }

  List<Widget> makeTile(String name, Icon icon, Function() onTap) {
    List<Widget> list = List<Widget>();
    list.add(
      LobbyButton(
        text: name,
        icon: icon,
        onTap: onTap,
      ),
    );

    list.add(
      Container(
        height: 20,
      ),
    );

    return list;
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
