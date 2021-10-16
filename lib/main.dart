import 'package:flutter/material.dart';
import 'screens/note_list.dart';
import 'screens/note_detail.dart';
import 'Drop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'SQFLite FLutter App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLite FLutter App',
      home: NoteList(),
    );
  }
}
