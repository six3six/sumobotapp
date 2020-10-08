import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/repositories/robots/robots_repository.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';

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
      create: (context) => FirestoreRobotsRepository(edition, context.repository<AuthenticationRepository>()),
      child: BlocProvider(
        create: (context) => RobotsCubit(
          context.repository<FirestoreRobotsRepository>(),
          edition,
        ),
        child: Scaffold(
          body: RobotsView(
          ),
        ),
      ),
    );
  }
}
