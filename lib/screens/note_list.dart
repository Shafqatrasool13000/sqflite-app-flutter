import 'package:flutter/material.dart';
import 'package:sqlitesmartherdnotesapp/screens/note_detail.dart';
import 'package:sqlitesmartherdnotesapp/utils/database_helper.dart';
import 'note_list.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqlitesmartherdnotesapp/models/model.dart';
import 'package:sqflite/utils/utils.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add),
          tooltip: 'Press to Add Note',
          onPressed: () {
            moveToNextPage(Note('', '', 2), 'Add Note');
          }),
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Card(
        child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              title: Text(this.noteList[index].title),
              leading: CircleAvatar(
                backgroundColor: getPriority(this.noteList[index].priority),
                child: showIcon(this.noteList[index].priority),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  _delete(context, noteList[index]);
                },
              ),
              subtitle: Text(this.noteList[index].date),
              onTap: () {
                moveToNextPage(this.noteList[index], 'Edit Note');
              },
            );
          },
        ),
      ),
    );
  }

  // Priority Color show
  Color getPriority(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

//Priority Icon show
  Icon showIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_circle_filled);
      case 2:
        return Icon(Icons.keyboard_arrow_right);
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note model) async {
    int result = await databaseHelper.deleteData(model.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Suceesfullt');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void moveToNextPage(Note model, String title) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NoteListDetail(title, model),
        ));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((value) {
      Future<List<Note>> noteListFuture =
          databaseHelper.getNoteList().then((value) {
        this.noteList = value;
        this.count = value.length;
        return value;
      });
    });
  }
}
