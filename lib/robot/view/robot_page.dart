import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/repositories/robots/firestore_robots_step_repository.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/robot/cubit/robot_cubit.dart';

import 'robot_view.dart';

class RobotPage extends StatelessWidget {
  const RobotPage({Key key, @required this.robot})
      : assert(robot != null),
        super(key: key);

  static Route route(Robot robot) {
    return MaterialPageRoute<void>(builder: (_) => RobotPage(robot: robot));
  }

  final Robot robot;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirestoreRobotsRepository(
          robot.edition, context.repository<AuthenticationRepository>()),
      child: RepositoryProvider(
        create: (context) => FirestoreRobotsStepsRepository(robot.edition),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            return BlocProvider(
              create: (context) => RobotCubit(
                robot,
                context.repository<FirestoreRobotsStepsRepository>(),
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
