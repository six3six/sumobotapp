import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Robot extends StatelessWidget {
  final String robotId;
  final String edition;

  Robot({
    Key key,
    @required this.robotId, @required this.edition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('editions')
        .doc(edition)
        .collection("robots").doc(robotId).get();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            floating: true,
            pinned: true,
            // Display a placeholder widget to visualize the shrinking size.
            flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
              "assets/kit-sumobot.jpg",
              fit: BoxFit.cover,
            )),
            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight: 400,
          ),
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                  ),
                  Text(
                    "Robot 1 id : " + robotId.toString(),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  RaisedButton(
                    child: Text("Changer l'image du robot"),
                    textColor: Colors.white,
                    onPressed: () {
                      /*...*/
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Avancement",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Row(
                          children: [
                            Icon(Icons.check),
                            Container(width: 10),
                            Text("Validation de l'inscription")
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.cancel),
                            Container(width: 10),
                            Text("Validation par le jury")
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.schedule),
                            Container(width: 10),
                            Text("Validation challonge")
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      child: Text("Supprimer le robot"),
                      textColor: Colors.white,
                      onPressed: () {
                        /*...*/
                      },
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                  Text(
                      "Présentez ce QR code à chaque étape de votre inscription"),
                  Center(
                    child: QrImage(
                      data: "Robot",
                      version: QrVersions.auto,
                      size: 300.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
