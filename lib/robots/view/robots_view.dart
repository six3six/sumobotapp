import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/robots/cubit/robots_cubit.dart';
import 'package:sumobot/robots/cubit/robots_state.dart';

class RobotsView extends StatelessWidget {
  final Edition edition;

  const RobotsView({Key key, @required this.edition})
      : assert(edition != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _AppBar(
          edition: edition,
        )
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  final Edition edition;

  const _AppBar({Key key, @required this.edition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
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
        buildWhen: (RobotsState prev, RobotsState next) =>  prev.isSearching != next.isSearching,
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
                  : Text("${edition.name}")),
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
