import 'package:flutter/material.dart';

class EditionsPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => EditionsPage());
  }

  const EditionsPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editions"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [],
      ),
    );
  }
}