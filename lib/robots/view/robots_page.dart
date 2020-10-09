import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';
import 'package:sumobot/robots/cubit/robots_state.dart';

import 'robots_view.dart';

class RobotsPage extends StatelessWidget {
  const RobotsPage({Key key, @required this.edition})
      : assert(edition != null),
        super(key: key);

  static Route route(Edition edition) {
    return MaterialPageRoute<void>(
        builder: (_) => RobotsPage(edition: edition));
  }

  final Edition edition;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirestoreRobotsRepository(
          edition, context.repository<AuthenticationRepository>()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          return BlocProvider(
            create: (context) => RobotsCubit(
              context.repository<FirestoreRobotsRepository>(),
              edition,
              state.user,
            ),
            child: Scaffold(
              body: RobotsView(),
              bottomNavigationBar: BlocBuilder<RobotsCubit, RobotsState>(
                builder: (BuildContext context, RobotsState state) {
                  return BottomNavigationBar(
                    currentIndex: state.isPersonal ? 1 : 0,
                    items: [
                      const BottomNavigationBarItem(
                        icon: const Icon(FontAwesomeIcons.globeEurope),
                        label: "Tous",
                      ),
                      const BottomNavigationBarItem(
                        icon: const Icon(FontAwesomeIcons.user),
                        label: "Moi",
                      ),
                    ],
                    onTap: (index) =>
                        context.bloc<RobotsCubit>().setPersonal(index == 1),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => _AddRobot(
                    user: state.user,
                    edition: edition,
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddRobot extends StatelessWidget {
  _AddRobot({
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
                edition, context.repository<AuthenticationRepository>());
            print(repo);
            repo.addNewRobot(robot);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
