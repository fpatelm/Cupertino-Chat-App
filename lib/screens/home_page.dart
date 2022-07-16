import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/screens/calls.dart';
import 'package:cupertino_chat_app/screens/chats.dart';
import 'package:cupertino_chat_app/screens/login/user_name.dart';
import 'package:cupertino_chat_app/screens/people.dart';
import 'package:cupertino_chat_app/screens/settings.dart';
import 'package:cupertino_chat_app/states/lib.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var screens = [Chats(), Calls(), People(), SettingsScreen()];

  @override
  void initState() {
    chatState.refreshChatsForCurrentUser();
    usersState.initUsersListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              label: "Chats",
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            ),
            BottomNavigationBarItem(
              label: "Calls",
              icon: Icon(CupertinoIcons.phone),
            ),
            BottomNavigationBarItem(
              label: "People",
              icon: Icon(CupertinoIcons.person_alt_circle),
            ),
            BottomNavigationBarItem(
              label: "Settings",
              icon: Icon(CupertinoIcons.settings_solid),
            )
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return screens[index];
        },
      ),
    );
  }
}
