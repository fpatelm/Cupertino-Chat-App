import 'package:cupertino_chat_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  UserName({Key? key}) : super(key: key);
  var _text = TextEditingController();
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
                    .updateProfile(displayName: _text.text);

                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => HomePage()));
              })
        ],
      ),
    );
  }
}
