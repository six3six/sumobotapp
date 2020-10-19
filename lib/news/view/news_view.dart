import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/authentication/bloc/authentication_bloc.dart';
import 'package:sumobot/news/cubit/news_cubit.dart';
import 'package:sumobot/news/cubit/news_state.dart';
import 'package:sumobot/repositories/news/model/new.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Text(
              "Bonjour\r\n${state.user.name}",
              style: textTheme.headline6,
              textAlign: TextAlign.left,
            );
          },
        ),
        const SizedBox(height: 30),
        Expanded(
          child: BlocBuilder<NewsCubit, NewsState>(
              builder: (context, NewsState state) {
            if (state.isLoading)
              return Center(child: CircularProgressIndicator());
            if (state.news.length > 0)
              return ListView(
                  children: state.news.map((New n) => _tile(n)).toList());
            return Text("Il n'y a pas d'infos pour le moment ;)");
          }),
        ),
      ]),
    );
  }
}

class _tile extends StatelessWidget {
  final New _new;

  const _tile(this._new, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: ListTile(
            title: Text(_new.title),
            subtitle: Text(
              _new.summary ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            leading: SizedBox(width: 70, child: Image.network(_new.media)),
            onTap: () {
              launch(_new.url);
            },
          ),
        ),
      ),
    );
  }
}
