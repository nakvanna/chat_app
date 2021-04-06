import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';

class DbController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  Future<QuerySnapshot> getUserByUsername({String filter}) async {
    return await _firebase
        .collection('Users')
        .where('filter', arrayContains: filter.toLowerCase())
        .get();
  }

  Future<QuerySnapshot> getUserByUID(String uid) async {
    return await _firebase
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  Future<QuerySnapshot> getUsernameByEmail(String email) async {
    return await _firebase
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> checkBeforeUploadUserInfo(String uid) {
    return _firebase.collection('Users').where('uid', isEqualTo: uid).get();
  }

  Future<void> uploadUserInfo({Map<String, dynamic> userMap}) async {
    print('uploadUserInfo');
    QuerySnapshot snapshot;
    try {
      snapshot = await checkBeforeUploadUserInfo(userMap['uid']);
      if (snapshot.docs.isEmpty) {
        await _firebase.collection('Users').add(userMap);
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<QuerySnapshot> checkBeforeCreateChatRoom(
      String myUsername, String partnerName) {
    return _firebase.collection('ChatRoom').where('ChatRoomId', whereIn: [
      '${myUsername}_$partnerName',
      '${partnerName}_$myUsername'
    ]).get();
  }

  Future<QuerySnapshot> checkBeforeCreateGroupMessage({String partnerId}) {
    return _firebase.collection('GroupMessage').where('MatchID', whereIn: [
      [Constants.myUID.value, partnerId],
      [partnerId, Constants.myUID.value],
    ]).get();
  }

  Future<void> createGroupMessage(
      {Map<String, dynamic> fieldMap,
      String partnerId,
      String deviceTokens}) async {
    QuerySnapshot snapshot;
    try {
      snapshot = await checkBeforeCreateGroupMessage(partnerId: partnerId);
      if (snapshot.docs.isEmpty) {
        await _firebase
            .collection('GroupMessage')
            .add(fieldMap)
            .then((value) => Get.toNamed('/private_message', arguments: {
                  "docId": value.id,
                  "username": fieldMap["Users"][1]['username'],
                  "photoUrl": fieldMap['Users'][1]['photoUrl'],
                  "deviceTokens": deviceTokens
                }));
      } else {
        var partnerInfo = snapshot.docs[0]
            .data()['Users']
            .where((e) => e['uid'] != Constants.myUID.value)
            .toList();
        Get.toNamed('/private_message', arguments: {
          "docId": snapshot.docs[0].id,
          "username": partnerInfo[0]['username'],
          "photoUrl": partnerInfo[0]['photoUrl'],
          "deviceTokens": deviceTokens
        });
      }
    } catch (e) {}
  }

  getGroupMessage({String myUID}) {
    return _firebase
        .collection('GroupMessage')
        .where('MatchID', arrayContains: myUID)
        .snapshots();
  }

  updateRecentlyMessage({String docId, recentlyMapField}) {
    _firebase
        .collection('GroupMessage')
        .doc(docId)
        .update({"Recently": recentlyMapField});
  }

  updateSeenInRecentlyMessage({String docId}) async {
    var recently, distinctSeen;
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await _firebase
          .collection('GroupMessage')
          .doc(docId)
          .get()
          .then((value) async {
        recently = value.data()['Recently'];
        recently['seen'].add(Constants.myUID.value);
        distinctSeen = recently['seen'].toSet().toList();
        await _firebase.collection('GroupMessage').doc(docId).update({
          'Recently': {
            "sentAt": recently['sentAt'],
            "message": recently['message'],
            "seen": distinctSeen,
            "sentBy": recently['sentBy']
          }
        });
      });
    });
  }

  updateSeenInsideMessage(
      {String groupMessageDocId, String messageDocId}) async {
    await _firebase
        .collection('GroupMessage')
        .doc(groupMessageDocId)
        .collection('Messages')
        .doc(messageDocId)
        .update({'isSeen': true});
  }

  addMessage({String docId, messageMap}) async {
    try {
      return await _firebase
          .collection('GroupMessage')
          .doc(docId)
          .collection('Messages')
          .add(messageMap)
          .then((value) => value.id);
    } catch (e) {
      return null;
    }
  }

  getMessages({String docId}) {
    return _firebase
        .collection('GroupMessage')
        .doc(docId)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
