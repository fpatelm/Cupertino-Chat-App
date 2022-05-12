import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/screens/chat_detail.dart';
import 'package:cupertino_chat_app/states/lib.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class People extends StatelessWidget {
  People({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: uid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('uid', isNotEqualTo: currentUser)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          }

          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text("People"),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return Observer(
                            builder: (_) => CupertinoListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        usersState.users[data['uid']]
                                                    ['picture'] !=
                                                null
                                            ? usersState.users[data['uid']]
                                                ['picture']
                                            : ''),
                                  ),
                                  onTap: () => callChatDetailScreen(
                                      context,
                                      usersState.users[data['uid']]['name'] !=
                                              null
                                          ? usersState.users[data['uid']]
                                              ['name']
                                          : '',
                                      data['uid']),
                                  title: Text(usersState.users[data['uid']]
                                              ['name'] !=
                                          null
                                      ? usersState.users[data['uid']]['name']
                                      : ''),
                                  subtitle: Text(usersState.users[data['uid']]
                                              ['status'] !=
                                          null
                                      ? usersState.users[data['uid']]['status']
                                      : ''),
                                ));
                      },
                    ).toList(),
                  ),
                )
              ],
            );
          }
          return Container();
        });
  }
}
