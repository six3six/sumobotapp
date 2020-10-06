import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/editions/cubit/editions_cubit.dart';
import 'package:sumobot/repositories/editions/firestore_editions_repository.dart';

import 'editions_view.dart';

class EditionsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => EditionsPage());
  }

  const EditionsPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RepositoryProvider(
        create: (context) => FirestoreEditionsRepository(),
        child: BlocProvider(
          create: (context) =>
              EditionsCubit(context.repository<FirestoreEditionsRepository>()),
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Editions"),
              ),
              body: EditionsView()),
        ));
  }
}
