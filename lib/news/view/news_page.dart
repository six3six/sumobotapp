import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumobot/drawer/view/sumo_drawer.dart';
import 'package:sumobot/news/cubit/news_cubit.dart';
import 'package:sumobot/news/view/news_view.dart';
import 'package:sumobot/repositories/news/rss_news_repository.dart';

class NewsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NewsPage());
  }

  const NewsPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => RssNewsRepository(),
      child: BlocProvider(
        create: (BuildContext context) =>
            NewsCubit(context.repository<RssNewsRepository>()),
        child: Scaffold(
          drawer: SumoDrawer(),
          appBar: AppBar(
            title: const Text("News"),
          ),
          body: NewsView(),

        ),
      ),
    );
  }
}
