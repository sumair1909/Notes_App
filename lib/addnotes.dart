import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/notes.dart';

class AddNote extends StatefulWidget {
  AddNote({Key key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  CollectionReference ref = FirebaseFirestore.instance.collection('notes');
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Notes()));
            },
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  ref.add({
                    'title': title.text,
                    'content': content.text
                  }).whenComplete(() => Navigator.pop(context));
                },
                child: Text('Save', style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 18)))
          ]),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 40),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[350]),
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(hintText: 'Title',border: InputBorder.none),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[350]),
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: TextField(
                    controller: content,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(hintText: 'Take a note...',border: InputBorder.none),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
