import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNote {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  var snackBar1 = SnackBar(
    content: const Text('Title and text are requried'),
  );
  var snackBar2 = SnackBar(
    content: const Text('Successfully updated'),
  );
  String id = '';
  EditNote(String title, String text, String id, BuildContext context) {
    print(title);
    _controller1.text = title;
    _controller2.text = text;
    this.id = id;
    updateNote(context);
  }
  updateData(String title, String text, String id) {
    FirebaseFirestore.instance
        .collection('NoteUser')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .doc(id)
        .update({
      'title': title,
      'text': text,
      'updated': DateTime.now(),
    });
  }

  updateNote(BuildContext context) {
    Get.defaultDialog(
      titleStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'FiraSans',
        fontWeight: FontWeight.bold,
      ),
      title: 'Edit note',
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
                labelText: 'Title',
                hintText: 'example title',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent)),
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
                updateData(_controller1.text, _controller2.text, id);
                ScaffoldMessenger.of(context).showSnackBar(snackBar2);
              }
              Get.back();
            },
            label: Text('Edit'),
            style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
            icon: Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}
