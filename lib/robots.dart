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
  final String editionName;

  const Robots({Key key, @required this.edition, @required this.editionName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      RobotsState(this.edition, this.editionName);
}

class RobotsState extends State<Robots> with SingleTickerProviderStateMixin {
  final String editionId;
  final String editionName;
  Random rand = Random();

  TextEditingController nameController = TextEditingController();
  String nameError;

  String error = "";

  bool loaded = false;

  CollectionReference robotsRef;

  Query allRobot;
  Query myRobot;

  RobotsState(this.editionId, this.editionName) {
    robotsRef = FirebaseFirestore.instance
        .collection("editions")
        .doc(this.editionId)
        .collection("robots");

    allRobot = robotsRef.orderBy("name");

    myRobot = robotsRef.where("owner",
        isEqualTo: FirebaseAuth.instance.currentUser.uid);
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
                edition: this.editionId,
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
                        } else if (snapshot.hasError) {
                          return Text(
                            "No image",
                            textAlign: TextAlign.center,
                          );
                        }
                        return CircularProgressIndicator();
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
    print(this.error);
    return Scaffold(
      appBar: AppBar(
        title: Text(this.editionName),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          Query query = tab == myTabs[0] ? allRobot : myRobot;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: FutureBuilder(
                  future: query.get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    Column c = Column(
                      children: !snapshot.hasData
                          ? [
                              Center(
                                  child: Text(snapshot.hasError
                                      ? snapshot.error
                                      : "Chargement"))
                            ]
                          : snapshot.data.docs
                              .map<Widget>((QueryDocumentSnapshot doc) =>
                                  makeCard(context, doc.get("name"), "", doc.id,
                                      doc.get("owner")))
                              .toList(),
                    );

                    if (snapshot.data?.docs?.length == 0) {
                      c.children.add(Text(
                        "La liste est vide \u{1F622}\n\nAjoutez dès maintenant votre robot !\n",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ));
                    }
                    if (tab == myTabs[1]) {
                      c.children.add(RaisedButton(
                        child: const Text(
                          "Ajouter un robot",
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            addRobotDialog(context);
                          });
                        },
                      ));
                    }
                    return c;
                  }),
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
                robotsRef
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
    properties.add(StringProperty('edition', editionId));
  }
}
