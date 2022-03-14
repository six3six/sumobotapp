import 'package:authentication_repository/authentication_repository.dart';
import 'package:editions_repository/firestore_editions_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robots_repository/firestore_robots_repository.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/robot/cubit/robot_cubit.dart';

import 'robot_view.dart';

class RobotPage extends StatelessWidget {
  const RobotPage({
    Key? key,
    required this.edition,
    required this.robot,
  }) : super(key: key);

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
          context.read<AuthenticationRepository>(),
          context.read<FirestoreEditionsRepository>(),
        ),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            return BlocProvider(
              create: (context) => RobotCubit(
                robot,
                edition,
                context.read<FirestoreRobotsRepository>(),
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
