import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'chat_state.g.dart';

// This is the class used by rest of your codebase
class ChatState = _ChatState with _$ChatState;

// The store-class
abstract class _ChatState with Store {
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  @observable
  Map<String, dynamic> messages = ObservableMap();

  @action
  void refreshChatsForCurrentUser() {
    var chatDocuments = [];
    chats
        .where('users.$currentUser', isNull: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      chatDocuments = snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> names = data['names'];
        names.remove(currentUser);

        return {'docid': doc.id, 'name': names.values.first};
      }).toList();

      chatDocuments.forEach((doc) {
        FirebaseFirestore.instance.collection('chats/${doc['docid']}/messages')
            .orderBy('createdOn',descending: true)
            .limit(1)
            .snapshots()
            .listen((QuerySnapshot snapshot) {
              if(snapshot.docs.isNotEmpty){
                messages[doc['name']] = {
                  'msg': snapshot.docs.first['msg'],
                  'time': snapshot.docs.first['createdOn'],
                  'friendName':doc['name'],
                  'friendUid':snapshot.docs.first['uid']
                };
              }

        });

      });



    });
  }
}
