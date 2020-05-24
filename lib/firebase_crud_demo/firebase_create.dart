import 'package:flutter/material.dart';
import 'NoteFirebase.dart';
import 'firestore.service.dart';

class FirebaseCreateNote extends StatefulWidget {
  final NoteFirebase note;

  const FirebaseCreateNote({Key key, this.note}) : super(key: key);
  @override
  _FirebaseCreateNoteState createState() => _FirebaseCreateNoteState();
}

class _FirebaseCreateNoteState extends State<FirebaseCreateNote> {
  final _formKey = GlobalKey<FormState>();

  String title;
  String discription;
  bool isEditMode = false;

  void onNoteSave() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        NoteFirebase note =
            NoteFirebase(title: title, discription: discription);
        await FirestoreService.createNote(note);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error to insert Note');
      print(e);
    }
  }

  void onNoteUpdate() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        NoteFirebase note = NoteFirebase(
          firebasseId: widget.note.firebasseId,
          title: title,
          discription: discription,
          createdAt: widget.note.createdAt,
        );
        await FirestoreService.updateNote(note);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error to update Note');
      print(e);
    }
  }

  Form createNoteForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Title field
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Note title',
              ),
              initialValue: title,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              onSaved: (value) {
                title = value;
              },
            ),
          ),
          // Discription field
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              minLines: 8,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Discription',
                hintText: 'Note discription',
              ),
              initialValue: discription,
              onSaved: (value) {
                discription = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isEditMode = widget.note != null;
    if (isEditMode) {
      title = widget.note?.title;
      discription = widget.note?.discription;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Update Note' : 'New Note'),
        actions: <Widget>[
          MaterialButton(
            onPressed: isEditMode ? onNoteUpdate : onNoteSave,
            child: Text(isEditMode ? 'UPDATE' : 'SAVE'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            createNoteForm(),
          ],
        ),
      ),
    );
  }
}
