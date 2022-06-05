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
        Observer(
          builder: (_) => SliverList(
            delegate: SliverChildListDelegate(
              usersState.people
                  .map(
                    (dynamic data) => CupertinoListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            data['picture'] != null ? data['picture'] : ''),
                      ),
                      onTap: () => callChatDetailScreen(
                          context,
                          data['name'] != null ? data['name'] : '',
                          data['uid']),
                      title: Text(data['name'] != null ? data['name'] : ''),
                      subtitle:
                          Text(data['status'] != null ? data['status'] : ''),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
