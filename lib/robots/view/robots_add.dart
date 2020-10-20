import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/editions_repository.dart';
import 'package:sumobot/repositories/editions/firestore_editions_repository.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';

class RobotsAdd extends StatelessWidget {
  RobotsAdd({
    Key key,
    @required this.user,
    @required this.edition,
  })  : assert(edition != null),
        assert(user != null),
        super(key: key);

  final User user;
  final Edition edition;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un robot'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text('Entrez le nom du robot : '),
            TextFormField(
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: 'Nom',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Ajouter'),
          onPressed: () async {
            Robot robot = Robot(
              owner: user,
              name: textEditingController.text,
              uid: "",
              edition: edition,
            );
            RobotsRepository repo = FirestoreRobotsRepository(
              edition.uid,
              context.repository<AuthenticationRepository>(),
              FirestoreEditionsRepository(),
            );
            print(repo);
            repo.addNewRobot(robot);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
