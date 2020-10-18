import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/repositories/robots/entities/step_entity.dart';
import 'package:sumobot/robot/cubit/robot_cubit.dart';
import 'package:sumobot/robot/cubit/robot_state.dart';

class RobotView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _AppBar(),
        _Dashboard(),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotCubit, RobotState>(
      buildWhen: (RobotState prev, RobotState next) => prev.image != next.image,
      builder: (BuildContext context, RobotState state) {
        return SliverAppBar(
          floating: true,
          pinned: true,
          expandedHeight: 200.0,
          // Display a placeholder widget to visualize the shrinking size.
          flexibleSpace: FlexibleSpaceBar(
            background: state.image,
          ),
        );
      },
    );
  }
}

class _Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (AuthenticationState prev, AuthenticationState next) =>
              prev.user != next.user,
          builder: (context, AuthenticationState authenticationState) {
            return BlocBuilder<RobotCubit, RobotState>(
              buildWhen: (RobotState prev, RobotState next) =>
                  prev.robot.owner != next.robot.owner,
              builder: (BuildContext context, RobotState state) {
                print(authenticationState.user.admin ||
                    authenticationState.user == state.robot.owner);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TitleBlock(),
                    authenticationState.user.admin ||
                            authenticationState.user.id == state.robot.owner.id
                        ? const _OwnerTools()
                        : const SizedBox(),
                    const _QR(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OwnerTools extends StatelessWidget {
  const _OwnerTools({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ChangeImageButton(),
        const _StepList(),
        const _DeleteRobotButton(),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocBuilder<RobotCubit, RobotState>(
      buildWhen: (RobotState prev, RobotState next) =>
          prev.robot.name != next.robot.name ||
          prev.robot.owner.name != next.robot.owner.name,
      builder: (BuildContext context, RobotState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              state.robot.name,
              textAlign: TextAlign.left,
              style: theme.textTheme.headline2,
            ),
            Text(
              state.robot.owner.name,
              style: theme.textTheme.subtitle1,
            )
          ],
        );
      },
    );
  }
}

class _StepList extends StatelessWidget {
  const _StepList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotCubit, RobotState>(
      buildWhen: (RobotState prev, RobotState next) => prev.step != next.step,
      builder: (BuildContext context, RobotState state) {
        return Column(
          children: [
            _StepTile(
              name: "Payé",
              status: state.step.isPayed,
            ),
            _StepTile(
              name: "Validé",
              status: state.step.isValidated,
            ),
            _StepTile(
              name: "Inscrit",
              status: state.step.isRegistered,
            ),
          ],
        );
      },
    );
  }
}

class _StepTile extends StatelessWidget {
  final StepStatus status;
  final String name;

  const _StepTile({Key key, @required this.status, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          getIcon(),
          Container(width: 10),
          Flexible(
            child: Text(
              "$name : ${getSubtext()}",
              textAlign: TextAlign.justify,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .merge(TextStyle(color: getColor())),
            ),
          ),
        ],
      ),
    );
  }

  Color getColor() {
    switch (status) {
      case StepStatus.OK:
        return Colors.green;
        break;
      case StepStatus.CANCELED:
        return Colors.red;
        break;
      case StepStatus.PENDING:
        return Colors.orange;
        break;
      case StepStatus.UNKNOWN:
        return Colors.orange;
        break;
    }

    return Colors.orange;
  }

  Icon getIcon() {
    switch (status) {
      case StepStatus.OK:
        return const Icon(Icons.check);
        break;
      case StepStatus.CANCELED:
        return const Icon(Icons.close);
        break;
      case StepStatus.PENDING:
        return const Icon(Icons.autorenew_rounded);
        break;
      case StepStatus.UNKNOWN:
        return const Icon(Icons.autorenew_rounded);
        break;
    }

    return const Icon(Icons.autorenew_rounded);
  }

  String getSubtext() {
    switch (status) {
      case StepStatus.OK:
        return "Ok";
        break;
      case StepStatus.CANCELED:
        return "Annulé";
        break;
      case StepStatus.PENDING:
        return "En attente";
        break;
      case StepStatus.UNKNOWN:
        return "En attente";
        break;
    }

    return "En attente";
  }
}

class _QR extends StatelessWidget {
  const _QR({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotCubit, RobotState>(
        buildWhen: (RobotState prev, RobotState next) =>
            prev.robot != next.robot,
        builder: (BuildContext context, RobotState state) {
          return Center(
            child: QrImage(
              data: "SUMOCODE;" + state.robot.edition.uid + ";" + state.robot.uid,
              version: QrVersions.auto,
              size: 300.0,
            ),
          );
        });
  }
}

class _ChangeImageButton extends StatelessWidget {
  const _ChangeImageButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: const Text("Changer l'image du robot"),
      textColor: Colors.white,
      onPressed: () => context.bloc<RobotCubit>().changePhoto(),
    );
  }
}

class _DeleteRobotButton extends StatelessWidget {
  const _DeleteRobotButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        child: const Text("Supprimer le robot"),
        textColor: Colors.white,
        onPressed: () => context.bloc<RobotCubit>().delete(context),
      ),
    );
  }
}
