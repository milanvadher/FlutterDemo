import 'package:flutter/material.dart';
import 'package:flutter_demo/menu.modal.dart';
import 'package:flutter_demo/settings.dart';
import './sql_demo/sql_demo.dart';
import 'firebase_chat_demo/firebase_chat_demo.dart';
import 'firebase_crud_demo/firebase_crud_demo.dart';
import 'local_notification_demo/local_notification_demo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Menu> menu = [
    Menu(
      title: 'Firebase CRUD',
      icon: Icons.group_work,
      routeTo: FirebaseDemo(),
      lightColor: Colors.orange,
      darkColor: Colors.orangeAccent,
    ),
    Menu(
      title: 'SQL Demo',
      icon: Icons.apps,
      routeTo: SQLDemo(),
      lightColor: Colors.purple,
      darkColor: Colors.purpleAccent,
    ),
    Menu(
      title: 'Firebase Chat',
      icon: Icons.chat,
      routeTo: FirebaseChatDemo(),
      lightColor: Colors.teal,
      darkColor: Colors.tealAccent,
    ),
    Menu(
      title: 'Local Notification',
      icon: Icons.notifications_active,
      routeTo: LocalNotificationDemo(),
      lightColor: Colors.blue,
      darkColor: Colors.blueAccent,
    ),
  ];

  Widget menuGrid({
    @required Menu menu,
  }) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => menu.routeTo,
              ),
            );
          },
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    menu.icon,
                    size: 56,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? menu.darkColor
                        : menu.lightColor,
                  ),
                ),
                Text(
                  '${menu.title}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
          ),
          itemCount: menu.length,
          itemBuilder: (BuildContext context, int index) {
            return menuGrid(menu: menu[index]);
          },
        ),
      ),
    );
  }
}
