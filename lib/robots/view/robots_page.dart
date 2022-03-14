import 'package:authentication_repository/authentication_repository.dart';
import 'package:editions_repository/firestore_editions_repository.dart';
import 'package:editions_repository/models/edition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robots_repository/firestore_robots_repository.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';
import 'package:sumobot/robots/cubit/robots_state.dart';

import 'robots_add.dart';
import 'robots_view.dart';

class RobotsPage extends StatelessWidget {
  const RobotsPage({
    Key? key,
    required this.edition,
  }) : super(key: key);

  static Route route(Edition edition) {
    return MaterialPageRoute<void>(
        builder: (_) => RobotsPage(edition: edition));
  }

  final Edition edition;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirestoreEditionsRepository(),
      child: RepositoryProvider(
        create: (context) => FirestoreRobotsRepository(
          edition.uid,
          context.read<AuthenticationRepository>(),
          context.read<FirestoreEditionsRepository>(),
        ),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            return BlocProvider(
              create: (context) => RobotsCubit(
                context.read<FirestoreRobotsRepository>(),
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
                          context.read<RobotsCubit>().setPersonal(index == 1),
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
      ),
    );
  }
}
