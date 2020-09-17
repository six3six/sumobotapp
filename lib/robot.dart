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

  Random rand = Random();

  final picker = ImagePicker();
  File imageFile;

  StorageReference imageRef;

  RobotState({
    @required this.robotId,
    @required this.edition,
  }) {
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
  }

  @override
  void dispose() {
    imageFile.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('editions')
              .doc(edition)
              .collection("robots")
              .doc(robotId)
              .get(),
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
              return CustomScrollView(
                slivers: <Widget>[
                  // Add the app bar to the CustomScrollView.
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    // Display a placeholder widget to visualize the shrinking size.
                    flexibleSpace: FlexibleSpaceBar(
                      background: imageFile.existsSync()
                          ? Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            )
                          : FutureBuilder(
                              future: FirebaseStorage.instance
                                  .ref()
                                  .child("robots")
                                  .child(FirebaseAuth.instance.currentUser.uid)
                                  .child(robotId + ".jpg")
                                  .writeToFile(imageFile)
                                  .future,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  if (snapshot.error.runtimeType ==
                                      PlatformException) {
                                    if ((snapshot.error as PlatformException)
                                            .code ==
                                        "download_error") {
                                      return Center(
                                          child: Text("Pas d'image",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .merge(TextStyle(
                                                      color: Colors.white))));
                                    }
                                  }
                                  return Center(
                                      child: Text(
                                    snapshot.error.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .merge(TextStyle(color: Colors.white)),
                                  ));
                                } else if (!snapshot.hasData) {
                                  return Center(
                                      child: Text(
                                    "Chargement...",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .merge(TextStyle(color: Colors.white)),
                                  ));
                                } else {
                                  return Image.file(
                                    imageFile,
                                    fit: BoxFit.cover,
                                  );
                                }
                              },
                            ),
                    ),
                    expandedHeight: 400,
                  ),
                  SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                          ),
                          Text(
                            robot.get("name"),
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .doc(robot.get("owner"))
                                .get(),
                            builder: (context, snapshot) {
                              String text;
                              if (snapshot.hasError) {
                                text = snapshot.error.toString();
                              } else if (!snapshot.hasData) {
                                text = "Chargement...";
                              } else {
                                text = "de " + snapshot.data.get("name");
                              }

                              return Text(
                                text,
                                style: Theme.of(context).textTheme.subtitle1,
                              );
                            },
                          ),
                          Container(
                            height: 10,
                          ),
                          RaisedButton(
                            child: const Text("Changer l'image du robot"),
                            textColor: Colors.white,
                            onPressed: () async {
                              final PickedFile pickedFile =
                                  await picker.getImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 60);

                              StorageUploadTask uploadtask = FirebaseStorage
                                  .instance
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
                                File(pickedFile.path).copy(tmpFile.path +
                                    "/robots/" +
                                    robotId +
                                    ".jpg");
                                File(pickedFile.path).copy(imageFile.path).then(
                                    (value) => setState(() => {
                                          imageCache.clear(),
                                          imageCache.clearLiveImages()
                                        }));
                              });

                              return showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  uploadtask.onComplete.whenComplete(
                                      () => Navigator.pop(context));
                                  return const AlertDialog(
                                      title: const Text('Upload'),
                                      content:
                                          const CircularProgressIndicator());
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
                                Row(
                                  children: [
                                    const Icon(Icons.check),
                                    Container(width: 10),
                                    const Text("Validation de l'inscription")
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.cancel),
                                    Container(width: 10),
                                    const Text("Validation par le jury")
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.schedule),
                                    Container(width: 10),
                                    const Text("Validation challonge")
                                  ],
                                ),
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
                                /*...*/
                              },
                            ),
                          ),
                          Container(
                            height: 30,
                          ),
                          const Text(
                              "Présentez ce QR code à chaque étape de votre inscription"),
                          Center(
                            child: QrImage(
                              data: edition + ";" + robot.id,
                              version: QrVersions.auto,
                              size: 300.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
