import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/screens/chat_detail.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  var list = [];
  var currentUser = FirebaseAuth.instance.currentUser.uid;
  @override
  void initState() {
    super.initState();
    var tempMsg = [];
    FirebaseFirestore.instance
        .collection('chats')
        .where('users.$currentUser', isEqualTo: null)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot document) async {
        await FirebaseFirestore.instance
            .collection('/chats/${document.id}/messages')
            .orderBy('createdOn', descending: true)
            .limit(1)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection('/users')
                .where('uid',
                    isEqualTo: querySnapshot.docs.first.data()!['uid'])
                .limit(1)
                .get()
                .then((QuerySnapshot querySnapshotUser) {
              print(querySnapshot.docs.first.data()!['msg']);
              print(querySnapshotUser.docs.first.data()!['uid']);
              print(querySnapshotUser.docs.first.data()!['name']);
              tempMsg.add({
                "msg": querySnapshot.docs.first.data()!['msg'],
                "uid": querySnapshotUser.docs.first.data()!['uid'],
                "name": querySnapshotUser.docs.first.data()!['name']
              });
            }).catchError((error) {});
          }
        }).catchError((error) {});
      });
    }).catchError((error) {});

    setState(() {
      list = tempMsg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text("Chats"),
        ),
        SliverList(
          delegate: SliverChildListDelegate(list.map((element) {
            return CupertinoListTile(
              title: Text(element['name']),
              subtitle: Text(element['msg']),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ChatDetail(
                      friendName: element['name'],
                      friendUid: element['uid'],
                    ),
                  ),
                );
              },
            );
          }).toList()),
        )
      ],
    );
  }
}
