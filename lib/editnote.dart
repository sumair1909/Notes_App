import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

//import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/objectnotes.dart';
import 'notes.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class EditNote extends StatefulWidget {
  DocumentSnapshot docToEdit;
  final Note note;
  EditNote({this.docToEdit, this.note});
  

	
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note> noteList;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  
  @override
  void initState() {
    title = TextEditingController(text: widget.docToEdit.data()['title']);
    content = TextEditingController(text: widget.docToEdit.data()['content']);
    // title.text= widget.note.title;
    // content.text= widget.note.content;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(backgroundColor: Colors.redAccent[700],
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
                onPressed: () {_save();
                  widget.docToEdit.reference.update({
                    'title': title.text,
                    'content': content.text
                  }).whenComplete(() => Navigator.pop(context));
                },style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.redAccent[700])),
                child: Text('Save', style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 18))),
            ElevatedButton(
                onPressed: () {setState(() {
                  _delete();
                });
                  widget.docToEdit.reference
                      .delete()
                      .whenComplete(() => Navigator.pop(context));
                },style: ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.redAccent[700])),
                child: Text('Delete', style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 18)))
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
                child: TextField(onChanged: (value){updateTitle();},
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
                  child: TextField(onChanged: (value){updateContent();},
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
   void _delete() async {
		Navigator.pop(context);
		int result = await databaseHelper.deleteNote(widget.note.id);
		if (result != 0) {
			updateListView();
		}
	}
  void updateTitle(){
    widget.note.title = title.text;
  }

	
	void updateContent() {
		widget.note.content = content.text;
	}

  void _save() async {
		Navigator.pop(context);
		if (widget.note.id != null) { 
			await databaseHelper.updateNote(widget.note);
		} else { 
			await databaseHelper.insertNote(widget.note);
		}

	

	}

	
  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				
				});
			});
		});
  }
}
