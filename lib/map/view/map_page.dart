import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

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
          Navigator.pop(context);
        },
      ),
      body: PhotoView(
        imageProvider: AssetImage("assets/plan.png"),
      ),
    );
  }
}
