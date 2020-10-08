import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sumobot/editions/cubit/editions_cubit.dart';
import 'package:sumobot/editions/cubit/editions_state.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';
import 'package:sumobot/robots/view/robots_page.dart';

class EditionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditionsCubit, EditionsState>(
        builder: (BuildContext context, EditionsState state) {
      if (state.editions.length == 0) context.bloc<EditionsCubit>().update();
      return ListView.builder(
        itemCount: state.editions.length,
        itemBuilder: (BuildContext context, int index) {
          return _EditionCard(edition: state.editions[index]);
        },
      );
    });
  }
}

final DateFormat _editionFormat = DateFormat('dd MMMM yyyy');

class _EditionCard extends StatelessWidget {
  final Edition edition;

  const _EditionCard({Key key, @required this.edition})
      : assert(edition != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Navigator.of(context).push(RobotsPage.route(edition)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: new Text(edition.name),
              subtitle: Text(_editionFormat.format(edition.date)),
              leading: Image.network(
                'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
