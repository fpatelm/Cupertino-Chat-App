import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_chat_app/auth_gate.dart';
import 'package:cupertino_chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const bool USE_EMULATOR = true;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (USE_EMULATOR) {
    _connectToFirebaseEmulator();
  }
  runApp(MyApp());
}

Future _connectToFirebaseEmulator() async {
  var firebaseConfig = await readJsonFile('firebase.json');
  final fireStorePort =
      firebaseConfig['emulators']['firestore']['port']; //8092;
  final authPort = firebaseConfig['emulators']['auth']['port']; //9099;
  final storagePort = firebaseConfig['emulators']['storage']['port'];
  final localHost = Platform.isAndroid
      ? '10.0.2.2'
      : firebaseConfig['emulators']['storage']['host'];

  FirebaseFirestore.instance.settings = Settings(
      host: "$localHost:$fireStorePort",
      sslEnabled: false,
      persistenceEnabled: false);
  await FirebaseStorage.instance.useStorageEmulator(localHost, storagePort);
  await FirebaseAuth.instance.useAuthEmulator(localHost, authPort);
}

dynamic readJsonFile(String filePath) async {
  final String response = await rootBundle.loadString(filePath);
  return await json.decode(response) as dynamic;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: CupertinoThemeData(
          brightness: Brightness.light, primaryColor: Color(0xFF08C187)),
    );
  }
}
