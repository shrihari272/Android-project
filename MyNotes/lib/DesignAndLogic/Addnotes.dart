import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNotes {
  var snackBar1 = SnackBar(
    content: const Text('Title and text are requried'),
  );
  final snackBar2 = SnackBar(
    content: const Text('Successfully added'),
  );
  addData(String user, String text) async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('NoteUser')
        .doc(userId)
        .collection('notes');
    var demoData = {
      'title': user,
      'text': text,
      'created': DateTime.now(),
    };
    collectionReference.add(demoData);
  }

  addNote(BuildContext context) {
    TextEditingController _controller1 = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    Get.defaultDialog(
      titleStyle: TextStyle(
        fontFamily: 'FiraSans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      title: 'Add note',
      backgroundColor: Colors.grey[800],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: TextField(
              controller: _controller1,
              scrollPadding: EdgeInsets.all(10.0),
              autofocus: true,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent)),
                labelText: 'Title',
                hintText: 'example title',
                labelStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: TextField(
              controller: _controller2,
              scrollPadding: EdgeInsets.all(10.0),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent)),
                labelText: 'Text',
                hintText: 'example text',
                labelStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 3.0,
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (_controller1.text == '' || _controller2.text == '')
                ScaffoldMessenger.of(context).showSnackBar(snackBar1);
              else {
                addData(_controller1.text, _controller2.text);
                ScaffoldMessenger.of(context).showSnackBar(snackBar2);
              }
              Get.back();
            },
            label: Text('Add'),
            style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
            icon: Icon(Icons.save),
          )
        ],
      ),
    );
  }
}
