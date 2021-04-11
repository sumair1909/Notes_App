//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/notes.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green, Colors.blue])),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment(0, -0.5),
                    child: Text(
                      "Welcome to Outline, Please Sign In To Continue",
                      style: GoogleFonts.pacifico(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                    child: Image.asset('assets/notes.jpg',
                        height: 300, width: 250),
                  ),
                  SizedBox(
                    height: 50,
                    width: 270,
                    child: ElevatedButton(
                        onPressed: () {
                          _signInWithGoogle();
                        },
                        child: Row(children: [
                          FaIcon(FontAwesomeIcons.google),
                          SizedBox(width: 40),
                          Text("Sign In With Google",
                              style: GoogleFonts.lato(fontSize: 20))
                        ]),style: ElevatedButton.styleFrom(
      primary: Colors.red[900],
      onPrimary: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final User user =
        (await firebaseAuth.signInWithCredential(credential)).user;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Notes()));
    
  }
}
