import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/confirm_dialog.dart';
import 'package:flutter_demo/google_login/auth.service.dart';
import 'package:flutter_demo/google_login/google_button.dart';
import 'NoteFirebase.dart';
import 'firebase_create.dart';
import 'firestore.service.dart';

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseDemoState createState() => _FirebaseDemoState();
}

class _FirebaseDemoState extends State<FirebaseDemo> {
  Future<List<NoteFirebase>> fetchNotes;
  StreamSubscription<FirebaseUser> streamSubscription;

  void onCreateNote() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FirebaseCreateNote(),
        fullscreenDialog: true,
      ),
    );
    loadNotes();
  }

  void loadNotes() async {
    setState(() {
      fetchNotes = FirestoreService.getNotes();
    });
  }

  Widget showNotes() {
    return FutureBuilder(
      future: fetchNotes,
      builder: (context, AsyncSnapshot<List<NoteFirebase>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return noteList(snapshot.data);
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'You don\'t have a Note yet',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Tap + to create one',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Update note in db
  void updateNote(NoteFirebase note) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FirebaseCreateNote(
          note: note,
        ),
        fullscreenDialog: true,
      ),
    );
    loadNotes();
  }

  // Delete note in db
  void deleteNote(NoteFirebase note) async {
    if (await Confirm().show(
        context: context, description: 'Do you want to delete this note ?')) {
      await FirestoreService.deleteNote(note.firebasseId);
      loadNotes();
    }
  }

  // All Notes from db
  Widget noteList(List<NoteFirebase> notes) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        NoteFirebase note = notes[index];
        return ListTile(
          isThreeLine: true,
          title: Text(note.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  note.discription,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.timer,
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Text(
                    note.updatedAt,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              )
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_outline,
            ),
            onPressed: () {
              deleteNote(note);
            },
          ),
          onTap: () {
            updateNote(note);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
    );
  }

  initData() async {
    await AuthService.checkUserLoginStatus();
    streamSubscription = AuthService.user.listen((value) {
      if (value != null) {
        loadNotes();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Demo'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: AuthService.user,
          builder: (
            context,
            AsyncSnapshot<FirebaseUser> snapshot,
          ) {
            if (snapshot.hasData) {
              return showNotes();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error),
              );
            }
            return Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Login to continue ...',
                    ),
                    SizedBox(height: 10),
                    GoogleButton().googleButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: StreamBuilder(
        stream: AuthService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              onPressed: onCreateNote,
              child: Icon(Icons.add),
            );
          }
          return Container();
        },
      ),
    );
  }
}
