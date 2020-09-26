import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:sumobot/robots.dart';

class Edition extends StatelessWidget {
  Edition({Key key}) : super(key: key);

  Widget makeCard(
      BuildContext context, String name, Timestamp date, String uid) {
    DateFormat format = DateFormat('dd MMMM yyyy');

    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Robots(
                edition: uid,
                editionName: name,
              ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: new Text(name),
              subtitle: Text(format.format(date.toDate())),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference editions =
        FirebaseFirestore.instance.collection('editions');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editions"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          FutureBuilder(
            future: editions.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map<Widget>((DocumentSnapshot document) => makeCard(
                            context,
                            document.get("name"),
                            document.get("date"),
                            document.id))
                        .toList());
              } else {
                return const Text("Chargement...");
              }
            },
          )
        ],
      ),
    );
  }
}
