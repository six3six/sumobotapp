import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sumobot/main.dart';
import 'package:sumobot/profile.dart';
import 'package:tuple/tuple.dart';

class Robot extends StatefulWidget {
  final String robotId;
  final String edition;

  const Robot({Key key, this.robotId, this.edition}) : super(key: key);

  @override
  State<Robot> createState() => RobotState(robotId: robotId, edition: edition);
}

class RobotState extends State<Robot> {
  final String robotId;
  final String edition;

  String robotName = "Chargement";
  String robotOwner = "Chargement";
  String robotOwnerId = "";

  IconData inscriptionIcon = Icons.sync;
  IconData juryIcon = Icons.sync;
  IconData challongeIcon = Icons.sync;

  Color inscriptionColor = Colors.black54;
  Color juryColor = Colors.black54;
  Color challongeColor = Colors.black54;

  Widget illustration = Text("");

  Random rand = Random();

  final picker = ImagePicker();
  File imageFile;

  bool admin = false;

  DocumentReference robotRef;
  StorageReference imageRef;

  RobotState({
    @required this.robotId,
    @required this.edition,
  }) {
    robotRef = FirebaseFirestore.instance
        .collection("editions")
        .doc(edition)
        .collection("robots")
        .doc(this.robotId);
    if (!Directory(tmpFile.path + "/robots/").existsSync())
      Directory(tmpFile.path + "/robots/").create();
    imageFile = File(tmpFile.path + "/robots/" + robotId + ".jpg");
    imageCache.clear();
    imageCache.clearLiveImages();
    imageRef = FirebaseStorage.instance
        .ref()
        .child("robots")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child(robotId + ".jpg");

    robotRef.get().then((doc) => setState(() {
          this.robotName = doc.get("name");
          this.robotOwnerId = doc.get("owner");
          FirebaseFirestore.instance
              .collection("users")
              .doc(robotOwnerId)
              .get()
              .then((user) =>
                  setState(() => this.robotOwner = "de " + user.get("name")));
        }));
    getImage();

    isAdmin(FirebaseAuth.instance.currentUser.uid)
        .then((value) => setState(() => admin = value));
  }

  @override
  void dispose() {
    if (imageFile.existsSync()) imageFile.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        child: FutureBuilder(
            future: robotRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    "Chargement...",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                );
              } else {
                DocumentSnapshot robot = snapshot.data;
                String owner = robot.get("owner");
                return CustomScrollView(
                  slivers: <Widget>[
                    // Add the app bar to the CustomScrollView.
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      // Display a placeholder widget to visualize the shrinking size.
                      flexibleSpace: FlexibleSpaceBar(
                        background: illustration,
                      ),
                      expandedHeight: 400,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: makeDashboard(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  List<Widget> makeDashboard(BuildContext context) {
    List<Widget> dashboard = [
      Container(
        height: 30,
      ),
      Text(
        this.robotName,
        style: Theme.of(context).textTheme.headline2,
      ),
      Text(
        this.robotOwner,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    ];
    if (robotOwnerId == FirebaseAuth.instance.currentUser.uid)
      dashboard.addAll(ownerDashboard());
    return dashboard;
  }

//.addAll(owner == FirebaseAuth.instance.currentUser.uid ? ownerDashboard() : [])
  List<Widget> ownerDashboard() {
    return [
      Container(
        height: 10,
      ),
      RaisedButton(
        child: const Text("Changer l'image du robot"),
        textColor: Colors.white,
        onPressed: () async {
          final PickedFile pickedFile = await picker.getImage(
              source: ImageSource.gallery, imageQuality: 60);

          StorageUploadTask uploadtask = FirebaseStorage.instance
              .ref()
              .child("robots")
              .child(FirebaseAuth.instance.currentUser.uid)
              .child(robotId + ".jpg")
              .putFile(File(pickedFile.path));

          uploadtask.onComplete.then((value) {
            imageFile.delete();
            imageFile = File(tmpFile.path +
                "/robots/" +
                robotId +
                rand.nextInt(999999).toString() +
                ".jpg");
            File(pickedFile.path)
                .copy(tmpFile.path + "/robots/" + robotId + ".jpg");
            this.illustration = Image.file(
              imageFile,
              fit: BoxFit.cover,
            );
            File(pickedFile.path).copy(imageFile.path).then((value) => setState(
                () => {imageCache.clear(), imageCache.clearLiveImages()}));
          });

          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              uploadtask.onComplete.whenComplete(() => Navigator.pop(context));
              return const AlertDialog(
                  title: const Text('Upload'),
                  content: const CircularProgressIndicator());
            },
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Avancement",
              style: Theme.of(context).textTheme.headline4,
            ),
            StatusBoard(
              sections: {
                "inscription": "Inscription validé",
                "jury": "Validation par le jury",
                "challonge": "Votre robot figure dans l'arbre de tournois",
              },
              isAdmin: this.admin,
              robotRef: robotRef,
            )
          ],
        ),
      ),
      SizedBox(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          child: const Text("Supprimer le robot"),
          textColor: Colors.white,
          onPressed: () {
            FirebaseFirestore.instance
                .collection("editions")
                .doc(this.edition)
                .collection("robots")
                .doc(this.robotId)
                .delete();
            Navigator.pop(context);
          },
        ),
      ),
      Container(
        height: 30,
      ),
      const Text(
        "Présentez ce QR code à chaque étape de votre inscription",
        textAlign: TextAlign.justify,
      ),
      Center(
        child: QrImage(
          data: this.edition + ";" + this.robotId,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    ];
  }

  Future<void> getImage() async {
    if (this.imageFile.existsSync()) {
      this.illustration = Image.file(
        this.imageFile,
        fit: BoxFit.cover,
      );
      return;
    }

    this.illustration = Center(
      child: Text(
        "Chargement...",
        style: TextStyle(color: Colors.white),
      ),
    );
    try {
      await imageRef.writeToFile(imageFile).future;
      setState(() => this.illustration = Image.file(
            imageFile,
            fit: BoxFit.cover,
          ));
    } on PlatformException catch (error) {
      if (error.code == "download_error") {
        setState(() {
          this.illustration = Center(
              child: Text("Pas d'image",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .merge(TextStyle(color: Colors.white))));
        });
      } else
        setState(() => this.illustration = Center(
                child: Text(
              error.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .merge(TextStyle(color: Colors.white)),
            )));
    } catch (error) {
      setState(() => this.illustration = Center(
              child: Text(
            error.toString(),
            style: Theme.of(context)
                .textTheme
                .headline2
                .merge(TextStyle(color: Colors.white)),
          )));
    }
  }
}

class StatusBoard extends StatefulWidget {
  final Map<String, String> sections;
  final DocumentReference robotRef;
  final bool isAdmin;

  const StatusBoard(
      {Key key,
      @required this.sections,
      @required this.robotRef,
      @required this.isAdmin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      StatusBoardState(this.sections, this.robotRef, this.isAdmin);
}

class StatusBoardState extends State<StatusBoard> {
  final Icon syncIcon = const Icon(Icons.sync);

  final List<Tuple2<Icon, Color>> statusSpecs = [
    Tuple2<Icon, Color>(
        const Icon(
          Icons.access_time,
          color: Colors.orange,
        ),
        Colors.orange),
    Tuple2<Icon, Color>(
        const Icon(
          Icons.check,
          color: Colors.green,
        ),
        Colors.green),
    Tuple2<Icon, Color>(
        const Icon(
          Icons.close,
          color: Colors.red,
        ),
        Colors.red),
  ];

  final Map<String, String> sections;
  final DocumentReference robotRef;

  final bool isAdmin;

  CollectionReference statusRef;

  Map<String, int> status = Map<String, int>();
  Map<String, bool> enable = Map<String, bool>();

  StatusBoardState(this.sections, this.robotRef, this.isAdmin) {
    this.statusRef = robotRef.collection("status");

    this.sections.forEach((key, value) async {
      this.enable[key] = false;
      DocumentSnapshot doc = await this.statusRef.doc(key).get();
      if (!doc.exists)
        this.status[key] = 0;
      else
        this.status[key] = doc.get("status") as int;
      this.enable[key] = true;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = List<Widget>();
    this.sections.forEach((key, value) {
      Widget icon = this.syncIcon;
      Color color = Colors.black38;

      if (enable[key]) {
        Tuple2<Icon, Color> spec = statusSpecs[status[key]];
        color = spec.item2;

        if (this.isAdmin) {
          List<bool> isSelected = new List<bool>();
          for (int i = 0; i < statusSpecs.length; i++)
            isSelected.add(status[key] == i);
          icon = ToggleButtons(
            children: statusSpecs
                .map<Icon>((Tuple2<Icon, Color> spec) => spec.item1)
                .toList(),
            onPressed: (int index) {
              setState(() {
                status[key] = index;
                statusRef.doc(key).set({"status": index});
              });
            },
            isSelected: isSelected,
          );
        } else {
          icon = spec.item1;
        }
      }

      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              icon,
              Container(width: 10),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .merge(TextStyle(color: color)),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Column(
      children: rows,
    );
  }
}
