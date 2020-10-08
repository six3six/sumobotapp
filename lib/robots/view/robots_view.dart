import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';
import 'package:sumobot/robots/cubit/robots_state.dart';

class RobotsView extends StatelessWidget {
  const RobotsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.bloc<RobotsCubit>().update();

    return CustomScrollView(
      slivers: [
        _AppBar(),
        _RobotList(),
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
          child: const Icon(Icons.search),
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
            print(state.isSearching);
            return FlexibleSpaceBar(
              centerTitle: state.isSearching,
              title: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
                  width: 220,
                  child: state.isSearching
                      ? const _SearchBar()
                      : Text("${state.edition.name}")),
              background: Image.network(
                'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
                fit: BoxFit.fitWidth,
              ),
            );
          }),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      keyboardType: TextInputType.text,
      placeholder: "Search..",
      placeholderStyle: TextStyle(
        color: Color(0xffC4C6CC),
        fontSize: 14.0,
        fontFamily: 'Brutal',
      ),
      prefix: Padding(
        padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
        child: Icon(Icons.search),
      ),
      suffix: RawMaterialButton(
        elevation: 0.0,
        child: const Icon(Icons.cancel),
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
    );
  }
}

class _RobotList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RobotsCubit, RobotsState>(
      builder: (BuildContext context, RobotsState state) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _RobotItem(state.robots[index % state.robots.length]);
            },
            childCount: state.robots.length * 100,
          ),
        );
      },
    );
  }
}

class _RobotItem extends StatelessWidget {
  final Robot robot;

  const _RobotItem(this.robot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Theme.of(context).buttonColor,
        onTap: () => null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircularProgressIndicator(),
              title: Text(robot.name),
              subtitle: Text(robot.owner),
            ),
          ],
        ),
      ),
    );
  }
}
