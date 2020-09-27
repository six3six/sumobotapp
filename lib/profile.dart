import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

Future<bool> isAdmin(String uid) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection("roles").doc("admins").get();
  Map<String, dynamic> data = doc.data();
  return data.containsKey(uid);
}

class Profile extends StatelessWidget {
  Profile({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final double paddingInput = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sumobot"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mon profile",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.left,
            ),
            Container(
              height: 15,
            ),
            Text(
              "Louis Desplanche",
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Ancien mot de passe',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: paddingInput),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Nouveau mot de passe',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: paddingInput),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Nouveau mot de passe',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // Process data.
                        }
                      },
                      textColor: Colors.white,
                      child: Text('Modifier le mot de passe'),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                child: Text(
                  "Supprimer mon compte",
                ),
                textColor: Colors.white,
                onPressed: () {
                  /*...*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
