import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlitesmartherdnotesapp/utils/database_helper.dart';
import 'note_list.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqlitesmartherdnotesapp/models/model.dart';
import 'package:sqflite/utils/utils.dart';

class NoteListDetail extends StatefulWidget {
  final String title;
  final Note model;
  NoteListDetail(this.title, this.model);
  @override
  _NoteListDetailState createState() => _NoteListDetailState(title, model);
}

DatabaseHelper helper = DatabaseHelper();

class _NoteListDetailState extends State<NoteListDetail> {
  String appBartTitle;
  Note note;
  _NoteListDetailState(this.appBartTitle, this.note);
  String dropDownValue = 'Low';
  List<String> items = ['High', 'Low'];
  List<DropdownMenuItem> priorityList() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (var item in items) {
      print(item);
      var itemsList = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      dropDownItems.add(itemsList);
    }
    return dropDownItems;
  }

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _title.text = note.title;
    _description.text = note.description;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          leading: GestureDetector(
              onTap: () {
                moveBackPage();
              },
              child: Icon(
                Icons.arrow_back,
              )),
          title: Text(appBartTitle),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              DropdownButton(
                  icon: Icon(Icons.add_circle_outline),
                  items: priorityList(),
                  value: getPriorityAsString(note.priority),
                  onChanged: (value) {
                    setState(() {
                      updatePriority(value);
                    });
                  }),
              Padding(
                padding: EdgeInsets.all(12),
              ),
              TextField(
                controller: _title,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              Padding(
                padding: EdgeInsets.all(12),
              ),
              TextField(
                controller: _description,
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        _save();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Expanded(
                    child: FlatButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        _delete();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  // Move back to the previous Screen
  void moveBackPage() {
    Navigator.pop(context, true);
  }

  //Update priority before Save it to the Database
  void updatePriority(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
      default:
        note.priority = 1;
    }
  }

  //Convert int priority from int to String
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = items[0]; //High
        break;
      case 2:
        priority = items[1]; //Low
    }
    return priority;
  }

  // Update the title
  void updateTitle() {
    note.title = _title.text;
  }

  //update the description
  void updateDescription() {
    note.description = _description.text;
  }

//Saving and Updating the data into the Database
  void _save() async {
    moveBackPage();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      //update it
      result = await helper.updateData(note);
    } else {
      //insert Data
      result = await helper.insertNote(note);
    }
    //Giving alert about Note update
    if (result != 0) {
      _alertDialog('Status', 'Note Saved Suceesful');
    } else {
      _alertDialog('Status', 'Problem Saving Note');
    }
  }

  void _alertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(message),
      title: Text(title),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    //When user delete new button when user click on fab but not saved it
    moveBackPage();
    if (note.id == null) {
      _alertDialog('Status', 'No Note Was Deleted');
      return;
    }
    int result = await helper.deleteData(note.id);
    if (result != null) {
      _alertDialog('status', 'Note Deleted Suceesfully');
    } else {
      _alertDialog('status', 'Problem Deleting Note');
    }
  }
}

class FieldOfNoteDetails extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Function onChanged;
  FieldOfNoteDetails(
      {this.onChanged, this.hintText, this.controller, this.labelText});
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
