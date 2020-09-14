import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sumobot/robot.dart';

class Robots extends StatefulWidget {
  final String edition;

  const Robots({Key key, this.edition}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RobotsState(edition);
}

class RobotsState extends State<Robots> {
  final String edition;

  TextEditingController nameController = TextEditingController();
  String nameError;

  CollectionReference robots;

  RobotsState(this.edition) {
    this.robots = FirebaseFirestore.instance
        .collection('editions')
        .doc(edition)
        .collection("robots");
  }

  Widget makeCard(BuildContext context, Image image, String name,
      String description, String uid) {
    return Card(
      child: InkWell(
        splashColor: Colors.red.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Robot(
                edition: edition,
                robotId: uid,
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: image,
              title: Text(name),
              subtitle: Text(description),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Robots"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            FutureBuilder(
              future: robots
                  .where("owner",
                      isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data.documents
                          .map<Widget>((DocumentSnapshot doc) => makeCard(
                              context,
                              Image.asset("assets/kit-sumobot.jpg"),
                              doc.get("name"),
                              "",
                              doc.id))
                          .toList());
                } else {
                  return const Text("Chargement...");
                }
              },
            ),
            RaisedButton(
              child: Text(
                "Ajouter un robot",
              ),
              textColor: Colors.white,
              onPressed: () {
                addRobotDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addRobotDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un robot'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Entrez le nom du robot : '),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Nom',
                    errorText: nameError,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ajouter'),
              onPressed: () {
                robots
                    .add({
                      "owner": FirebaseAuth.instance.currentUser.uid,
                      "name": nameController.text,
                      "image": "",
                    })
                    .then((value) => setState(() => {nameController.text = ""}))
                    .catchError(
                        (error) => print("Failed to add robot: $error"));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('edition', edition));
  }
}
