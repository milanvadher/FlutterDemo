import 'package:flutter/material.dart';
import './networking_demo/networking_demo.dart';
import './sql_demo/sql_demo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget listItem({
    @required String title,
    @required Widget routeTo,
  }) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => routeTo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            listItem(title: 'Networking', routeTo: NetworkingDemo()),
            listItem(title: 'SQL', routeTo: SQLDemo()),
          ],
        ),
      ),
    );
  }
}
