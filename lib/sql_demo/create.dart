import 'package:flutter/material.dart';
import 'note.model.dart';
import 'sql.helper.dart';

class CreateNote extends StatefulWidget {
  final Note note;

  const CreateNote({Key key, this.note}) : super(key: key);
  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  // reference to our single class that manages the database
  final sqlHelper = SQLHelper.instance;

  final _formKey = GlobalKey<FormState>();

  String title;
  String discription;
  bool isEditMode = false;

  void onNoteSave() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Note note = Note(title: title, discription: discription);
        await sqlHelper.insertNote(note);
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
        Note note = Note(
          id: widget.note.id,
          title: title,
          discription: discription,
          createdAt: widget.note.createdAt,
        );
        await sqlHelper.updateNote(note);
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
