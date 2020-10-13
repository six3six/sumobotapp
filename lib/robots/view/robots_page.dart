import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';
import 'package:sumobot/robots/cubit/robots_state.dart';

import 'robots_add.dart';
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
                  builder: (BuildContext context) => RobotsAdd(
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
