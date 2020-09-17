import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sumobot/robot.dart';

import 'main.dart';

class Robots extends StatefulWidget {
  final String edition;

  const Robots({Key key, this.edition}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RobotsState(edition);
}

class RobotsState extends State<Robots> with SingleTickerProviderStateMixin {
  final String edition;
  Random rand = Random();

  TextEditingController nameController = TextEditingController();
  String nameError;

  CollectionReference robots;

  RobotsState(this.edition) {
    this.robots = FirebaseFirestore.instance
        .collection('editions')
        .doc(edition)
        .collection("robots");
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Tout'),
    Tab(text: 'Mes robots'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.index = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget makeCard(BuildContext context, String name, String description,
      String uid, String owner) {
    File imageFile = File(tmpFile.path + "/robots/" + uid + ".jpg");
    return Card(
      child: InkWell(
        splashColor: Theme.of(context).buttonColor,
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
              leading: imageFile.existsSync()
                  ? Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    )
                  : FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child("robots")
                          .child(FirebaseAuth.instance.currentUser.uid)
                          .child(uid + ".jpg")
                          .writeToFile(imageFile)
                          .future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          );
                        } else
                          return const Text("");
                      },
                    ),
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
        title: const Text("Robots"),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          Query query;
          if (tab == myTabs[1])
            query = robots.where("owner",
                isEqualTo: FirebaseAuth.instance.currentUser.uid);
          else
            query = robots.orderBy("name");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                FutureBuilder(
                  future: query.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.documents
                              .map<Widget>((DocumentSnapshot doc) => makeCard(
                                  context,
                                  doc.get("name"),
                                  "",
                                  doc.id,
                                  doc.get("owner")))
                              .toList());
                    } else {
                      return const Text("Chargement...");
                    }
                  },
                ),
                RaisedButton(
                  child: const Text(
                    "Ajouter un robot",
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    addRobotDialog(context);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> addRobotDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un robot'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Entrez le nom du robot : '),
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
              child: const Text('Ajouter'),
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
