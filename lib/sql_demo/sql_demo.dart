import 'package:flutter/material.dart';
import 'package:flutter_demo/common/confirm_dialog.dart';
import 'package:flutter_demo/sql_demo/sql.helper.dart';
import './create.dart';
import 'note.model.dart';

class SQLDemo extends StatefulWidget {
  @override
  _SQLDemoState createState() => _SQLDemoState();
}

class _SQLDemoState extends State<SQLDemo> {
  // reference to our single class that manages the database
  final sqlHelper = SQLHelper.instance;
  Future<List<Note>> futureNote;

  // Add A new Note in db
  void addNewNote() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNote(),
        fullscreenDialog: true,
      ),
    );
    updateUI();
  }

  // Update note in db
  void updateNote(Note note) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNote(
          note: note,
        ),
        fullscreenDialog: true,
      ),
    );
    updateUI();
  }

  // Delete note in db
  void deleteNote(Note note) async {
    if (await Confirm().show(
        context: context, description: 'Do you want to delete this note ?')) {
      await sqlHelper.deleteNote(note.id);
      updateUI();
    }
  }

  void updateUI() {
    setState(() {
      futureNote = sqlHelper.fetchNotes();
    });
  }

  // All Notes from db
  Widget noteList(List<Note> notes) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        Note note = notes[index];
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

  @override
  void initState() {
    super.initState();
    futureNote = sqlHelper.fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQL Demo'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureNote,
          builder: (context, AsyncSnapshot<List<Note>> snapshot) {
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewNote,
        tooltip: 'Add Note',
      ),
    );
  }
}
