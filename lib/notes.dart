import 'dart:math';


import 'database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'objectnotes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/addnotes.dart';
import 'package:notes_app/editnote.dart';

class Notes extends StatefulWidget {
  Notes({Key key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  DatabaseHelper databaseHelper = DatabaseHelper();
	List<Note> noteList;
  final ref = FirebaseFirestore.instance.collection('notes');
  List<Color> myColors = [
    Colors.yellow,
    Colors.red[400],
    Colors.teal[300],
    Colors.purple[400],
    Colors.orange[300],
    Colors.lightBlue[300],
    Colors.lime
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent[700],
            title: Text('Outline', style: GoogleFonts.pacifico(fontSize: 20))),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent[700],
          child: FaIcon(FontAwesomeIcons.plus),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddNote()));
          },
        ),
        body: Container(
          child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                    itemBuilder: (_, index) {
                      Random random = new Random();
                      Color bg = myColors[random.nextInt(7)];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNote(
                                    docToEdit: snapshot.data.docs[index],
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: bg,
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          margin: EdgeInsets.all(10),
                          height: 150,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Text( 
                                    snapshot.data.docs[index].data()['title'],
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(height: 7),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                  child: Text(
                                      snapshot.data.docs[index]
                                          .data()['content'],
                                      style: GoogleFonts.lato(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                )
                              ]),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
 

}
 

