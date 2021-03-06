import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sumobot/news/view/news_page.dart';

class MapPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MapPage());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.fullscreen_exit),
        onPressed: () {
          Navigator.push(context, NewsPage.route());
        },
      ),
      body: PhotoView(
        imageProvider: AssetImage("assets/plan.png"),
      ),
    );
  }
}
