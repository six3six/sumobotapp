import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/repositories/editions/editions_repository.dart';
import 'package:sumobot/repositories/editions/firestore_editions_repository.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/repositories/robots/firestore_robots_step_repository.dart';
import 'package:sumobot/robot/cubit/robot_cubit.dart';

import 'robot_view.dart';

class RobotPage extends StatelessWidget {
  const RobotPage({
    Key key,
    @required this.edition,
    @required this.robot,
  })  : assert(robot != null),
        assert(edition != null),
        super(key: key);

  static Route route(String edition, String robot) {
    return MaterialPageRoute<void>(
      builder: (_) => RobotPage(
        robot: robot,
        edition: edition,
      ),
    );
  }

  final String robot;
  final String edition;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirestoreEditionsRepository(),
      child: RepositoryProvider(
        create: (context) => FirestoreRobotsRepository(
          edition,
          context.repository<AuthenticationRepository>(),
          context.repository<FirestoreEditionsRepository>(),
        ),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            return BlocProvider(
              create: (context) => RobotCubit(
                robot,
                edition,
                context.repository<FirestoreRobotsRepository>(),
              ),
              child: Scaffold(
                body: RobotView(),
              ),
            );
          },
        ),
      ),
    );
  }
}
