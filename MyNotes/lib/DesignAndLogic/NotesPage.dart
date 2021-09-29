import 'package:calculator/DesignAndLogic/Addnotes.dart';
import 'package:calculator/DesignAndLogic/splashScreen.dart';
import 'package:calculator/DesignAndLogic/EditNote.dart';
import 'package:calculator/DesignAndLogic/EmptyPage.dart';
import 'package:calculator/DesignAndLogic/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class NotesPage extends StatelessWidget {
  Splash myApp = Splash();

  var ref = FirebaseFirestore.instance
      .collection('NoteUser')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  var _scrollcontroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        shadowColor: Colors.grey[700],
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
                ref.get().then((QuerySnapshot querySnapshot) async {
                  if (querySnapshot.docs.length == 0) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => EmptyPage()));
                  }
                });
                return ListView(
                    controller: _scrollcontroller,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((user) {
                      return TextButton(
                        onPressed: () {
                          EditNote(user['title'], user['text'],
                              user.reference.id, context);
                        },
                        child: Card(
                          color: Colors.grey[800],
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(10.0)),
                                padding: EdgeInsets.only(
                                    top: 15.0, left: 10.0, bottom: 10.0),
                                child: Text(
                                  user['title'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Oswald',
                                    fontSize: 15.0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Card(
                                color: Colors.grey[600],
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                user['text'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'PTSerif',
                                                  fontSize: 15.0,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                deleteNote(
                                                    user.reference, context);
                                              },
                                              icon: Icon(
                                                Icons.delete_forever_outlined,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList());
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

  deleteNote(DocumentReference user, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Delete"),
          content: Text("Are you sure to delete this note?"),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                user.delete();
              },
            ),
          ],
        );
      },
    );
  }
}
