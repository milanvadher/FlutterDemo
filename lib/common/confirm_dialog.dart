import 'package:flutter/material.dart';

class Confirm {
  Future<bool> show({
    @required BuildContext context,
    String title = "Are you sure ?",
    String description = "Do you want to proceed ?",
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('YES'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('NO'),
            ),
          ],
        );
      },
    );
  }
}
