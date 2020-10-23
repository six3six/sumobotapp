import 'dart:io';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:editions_repository/models/edition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:robots_repository/firestore_robots_repository.dart';
import 'package:robots_repository/models/robot.dart';
import 'package:sumobot/robot/cubit/robot_state.dart';
import 'package:sumobot/robot/view/robot_page.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';
import 'package:sumobot/robots/cubit/robots_state.dart';
import 'package:sumobot/theme.dart';

class RobotsView extends StatelessWidget {
  const RobotsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.bloc<RobotsCubit>().update();

    return CustomScrollView(
      slivers: [
        const _AppBar(),
        const _RobotList(),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      expandedHeight: 150.0,
      actions: <Widget>[
        RawMaterialButton(
          elevation: 0.0,
          child: const Icon(
            Icons.search,
            color: sumoRed,
          ),
          onPressed: () => context.bloc<RobotsCubit>().setSearchModeToggle(),
          constraints: const BoxConstraints.tightFor(
            width: 56,
            height: 56,
          ),
          shape: const CircleBorder(),
        ),
      ],
      flexibleSpace: BlocBuilder<RobotsCubit, RobotsState>(
          buildWhen: (RobotsState prev, RobotsState next) =>
              prev.isSearching != next.isSearching ||
              prev.edition != next.edition,
          builder: (BuildContext context, RobotsState state) {
            return FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: const EdgeInsets.only(bottom: 2),
                constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
                width: 220,
                child: _SearchBar(
                  isSearching: state.isSearching,
                  edition: state.edition,
                ),
              ),
              background: Image.asset(
                'assets/' + state.edition.uid + ".png",
                fit: BoxFit.fitWidth,
              ),
            );
          }),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar(
      {Key key, @required this.isSearching, @required this.edition})
      : super(key: key);

  final bool isSearching;
  final Edition edition;

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSizeAndFade(
      vsync: this,
      child: widget.isSearching
          ? CupertinoTextField(
              keyboardType: TextInputType.text,
              placeholder: "Search..",
              onChanged: (text) => context.bloc<RobotsCubit>().search(text),
              placeholderStyle: const TextStyle(
                color: const Color(0xffC4C6CC),
                fontSize: 14.0,
                fontFamily: 'Brutal',
              ),
              prefix: const Padding(
                padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                child: const Icon(
                  Icons.search,
                  color: sumoRed,
                ),
              ),
              suffix: RawMaterialButton(
                elevation: 0.0,
                child: const Icon(
                  Icons.cancel,
                  color: sumoRed,
                ),
                onPressed: () => context.bloc<RobotsCubit>().setNormalMode(),
                constraints: const BoxConstraints.tightFor(
                  width: 56,
                  height: 56,
                ),
                shape: const CircleBorder(),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
            )
          : Stack(
              children: [
                Text(
                  "${widget.edition.name}",
                  style: Theme.of(context).textTheme.headline5.merge(TextStyle(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black,
                      )),
                ),
                Text(
                  "${widget.edition.name}",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .merge(TextStyle(color: sumoRed)),
                ),
              ],
            ),
    );
  }
}

class _RobotList extends StatelessWidget {
  const _RobotList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotsCubit, RobotsState>(
      builder: (BuildContext context, RobotsState state) {
        if (state.isLoading) {
          return const SliverToBoxAdapter(
            child: const Padding(
              padding: const EdgeInsets.only(top: 50),
              child: const Center(
                child: const SizedBox(
                  height: 80,
                  width: 80,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Column(
            children: state.robots
                .map((Robot robot) => _RobotItem(state.edition, robot))
                .toList(),
          ),
        );
      },
    );
  }
}

class _RobotImage extends StatefulWidget {
  final Robot robot;

  _RobotImage({Key key, @required this.robot}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RobotImageState();
}

class _RobotImageState extends State<_RobotImage> {
  bool isCharged = false;
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    if (!isCharged) {
      final robotRepo = context.repository<FirestoreRobotsRepository>();
      robotRepo.getImage(widget.robot).then((value) {
        setState(() {
          isCharged = true;
          imagePath = value;
        });
      });
      return const CircularProgressIndicator();
    }

    File image = File(imagePath);
    if (image.existsSync()) return Image.file(image);
    return const Icon(FontAwesomeIcons.question);
  }
}

class _RobotItem extends StatelessWidget {
  final Robot robot;
  final Edition edition;

  const _RobotItem(this.edition, this.robot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Theme.of(context).buttonColor,
        onTap: () =>
            Navigator.push(context, RobotPage.route(edition.uid, robot.uid)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: new _RobotImage(
                robot: robot,
              ),
              title: Text(robot.name),
              subtitle: Text(robot.owner.name),
            ),
          ],
        ),
      ),
    );
  }
}
