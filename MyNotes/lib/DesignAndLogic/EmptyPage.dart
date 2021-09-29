import 'package:calculator/DesignAndLogic/Addnotes.dart';
import 'package:calculator/DesignAndLogic/NotesPage.dart';
import 'package:calculator/DesignAndLogic/splashScreen.dart';
import 'package:calculator/DesignAndLogic/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmptyPage extends StatelessWidget {
  Splash myApp = Splash();

  var ref = FirebaseFirestore.instance
      .collection('NoteUser')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              myApp.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Start()));
            },
            icon: Icon(Icons.logout),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text(
          'My Notes',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StreamBuilder(
              stream: ref.orderBy('text').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                ref.get().then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.docs.length != 0) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NotesPage()));
                  }
                });
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 200),
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      children: [
                        Image.asset(
                          'images/Empty.png',
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Nothing found!',
                          style: TextStyle(fontSize: 23.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddNotes addnotes = AddNotes();
          addnotes.addNote(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent[400],
      ),
    );
  }
}
