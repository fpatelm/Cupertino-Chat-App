import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'users_state.g.dart';

// This is the class used by rest of your codebase
class UsersState = _UsersState with _$UsersState;

abstract class _UsersState with Store {
  var _currentUser = FirebaseAuth.instance.currentUser?.uid;

  @observable
  Map<String, dynamic> users = ObservableMap();
  final ImagePicker _picker = ImagePicker();

  @observable
  File? imagefile;

  var _profilePicUrl;
  var _usersCollection = FirebaseFirestore.instance.collection('users');

  @observable
  String _searchUser = '';

  @computed
  List<dynamic> get people {
    return users.entries
        .where((user) => user.key != _currentUser)
        .where((user) => user.value['name']
            .toLowerCase()
            .startsWith(_searchUser.toLowerCase()))
        .map((e) => e.value)
        .toList();
  }

  @action
  setSearchTerm(String value) {
    this._searchUser = value;
  }

  @action
  initUsersListener() {
    FirebaseFirestore.instance.collection("users").snapshots().listen(
      (QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          users[data['uid']] = {
            'name': data['name'],
            'phone': data['phone'],
            'status': data['status'],
            'picture': data['picture']
          };
        });
      },
    );
  }

  void takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    imagefile = File(image!.path);
    _uploadFile();
  }

  void _uploadFile() {
    if (imagefile == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final profileImagesRef = storageRef
        .child('${FirebaseAuth.instance.currentUser?.uid}/photos/profile.jpg');

    profileImagesRef.putFile(imagefile!).snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          // ...
          break;
        case TaskState.success:
          profileImagesRef
              .getDownloadURL()
              .then((value) => _profilePicUrl = value);
          break;
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          // ...
          break;
      }
    });
  }

  void createOrUpdateUserInFirestore(String userName) {
    FirebaseAuth.instance.currentUser?.updateDisplayName(userName);
    var docId;
    this._usersCollection
      ..where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .limit(1)
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          //create user info in firestore use case
          if (querySnapshot.docs.isEmpty) {
            this._usersCollection.add({
              'name': userName,
              'phone': FirebaseAuth.instance.currentUser?.phoneNumber,
              'status': 'Available',
              'uid': FirebaseAuth.instance.currentUser?.uid,
              'picture': _profilePicUrl
            });
          } else {
            docId = querySnapshot.docs.first.id;
          }
          //update user info in firestore use case
          if (docId != null) {
            this._usersCollection.doc(docId).update({
              'name': userName,
              'phone': FirebaseAuth.instance.currentUser?.phoneNumber,
              'status': 'Available',
              'uid': FirebaseAuth.instance.currentUser?.uid,
              'picture': _profilePicUrl
            });
          }
        },
      ).catchError((error) {});
  }
}
