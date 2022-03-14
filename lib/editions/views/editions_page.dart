import 'package:editions_repository/firestore_editions_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/drawer/view/sumo_drawer.dart';
import 'package:sumobot/editions/cubit/editions_cubit.dart';

import 'editions_view.dart';

class EditionsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => EditionsPage());
  }

  const EditionsPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirestoreEditionsRepository(),
      child: BlocProvider(
        create: (context) =>
            EditionsCubit(context.watch<FirestoreEditionsRepository>()),
        child: Scaffold(
          drawer: SumoDrawer(),
          appBar: AppBar(
            title: const Text("Editions"),
          ),
          body: EditionsView(),
        ),
      ),
    );
  }
}
