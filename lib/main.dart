import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/screens/calls.dart';
import 'package:cupertino_chat_app/screens/chats.dart';
import 'package:cupertino_chat_app/screens/people.dart';
import 'package:cupertino_chat_app/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const bool USE_EMULATOR = true;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_EMULATOR) {
    _connectToFirebaseEmulator();
  }
  runApp(MyApp());
}

Future _connectToFirebaseEmulator() async {
  final fireStorePort = "8089";
  final authPort = "9099";
  final localHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      host: "$localHost:$fireStorePort",
      sslEnabled: false,
      persistenceEnabled: false);

  await FirebaseAuth.instance.useEmulator("http://$localHost:$authPort");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomePage(),
      theme: CupertinoThemeData(
          brightness: Brightness.light, primaryColor: Color(0xFF08C187)),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  var screens = [Chats(), Calls(), People(), SettingsScreen()];

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
