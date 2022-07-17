import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/screens/chat_detail.dart';
import 'package:cupertino_chat_app/states/lib.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterfire_ui/firestore.dart';

// ignore: must_be_immutable
class People extends StatelessWidget {
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
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text("People"),
        ),
        SliverToBoxAdapter(
          key: UniqueKey(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CupertinoSearchTextField(
              onChanged: (value) => usersState.setSearchTerm(value),
              onSubmitted: (value) => usersState.setSearchTerm(value),
            ),
          ),
        ),
        SliverFillRemaining(
          child: Observer(builder: (_) {
            return FirestoreListView<Map<String, dynamic>>(
                query: FirebaseFirestore.instance
                    .collection('users')
                    .where('name',
                        isGreaterThanOrEqualTo: "${usersState.searchUser}")
                    .where('name',
                        isLessThanOrEqualTo: "${usersState.searchUser}\uf7ff"),
                itemBuilder: (context, snapshot) {
                  Map<String, dynamic> data = snapshot.data();
                  if (data['uid'] == currentUser) {
                    return Container();
                  }
                  return CupertinoListTile(
                    key: UniqueKey(),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data['picture']),
                    ),
                    onTap: () => callChatDetailScreen(
                        context, data['name'], data['uid']),
                    title: Text(data['name']),
                    subtitle: Text(data['status']),
                  );
                });
          }),
        ),
      ],
    );
  }
}
