import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  UserName({Key? key}) : super(key: key);
  var _text = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void createUserInFirestore() {
    users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          users.add({
            'name': _text.text,
            'phone': FirebaseAuth.instance.currentUser?.phoneNumber,
            'status': 'Available',
            'uid': FirebaseAuth.instance.currentUser?.uid
          });
        }
      },
    ).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter your name"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 55),
            child: CupertinoTextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
              maxLength: 15,
              controller: _text,
              keyboardType: TextInputType.name,
              autofillHints: <String>[AutofillHints.name],
            ),
          ),
          CupertinoButton.filled(
              child: Text("Continue"),
              onPressed: () {
                FirebaseAuth.instance.currentUser
                    ?.updateDisplayName( _text.text);

                createUserInFirestore();

                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => HomePage()));
              })
        ],
      ),
    );
  }
}
