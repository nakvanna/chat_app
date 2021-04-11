import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/shared_prefs_controller.dart';
import 'package:pks_mobile/helper/constants.dart';

class DbController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  final sharedPrefs = Get.find<SharedPrefs>();

  getUsers() {
    try {
      return _firebase.collection('Users').snapshots();
    } catch (e) {
      return e;
    }
  }

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

  Future<QuerySnapshot> checkBeforeUploadUserInfo(String uid) async {
    return await _firebase
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  Future<void> uploadUserInfo({Map<String, dynamic> userMap}) async {
    QuerySnapshot snapshot;

    try {
      snapshot = await checkBeforeUploadUserInfo(userMap['uid']);

      if (snapshot.docs.isEmpty) {
        var res = await _firebase.collection('Users').add(userMap);
        await sharedPrefs.setUserDocId(docId: res.id);
      } else {
        await updateUserInfo(
            docId: snapshot.docs[0].id,
            updateField: {'deviceToken': userMap['deviceToken']});
      }
    } catch (error) {
      print('Upload user info error: $error');
    }
  }

  updateUserInfo({String docId, Map<String, dynamic> updateField}) async {
    await _firebase.collection('Users').doc(docId).update(updateField);
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

  updateUsersInGroupMessage({String docId, List<dynamic> users}) async {
    await _firebase
        .collection('GroupMessage')
        .doc(docId)
        .update({"Users": users});
  }

  Future<String> createGroupMessage({
    Map<String, dynamic> fieldMap,
    String partnerId,
  }) async {
    QuerySnapshot snapshot;

    try {
      snapshot = await checkBeforeCreateGroupMessage(partnerId: partnerId);

      if (snapshot.docs.isEmpty) {
        var result = await _firebase.collection('GroupMessage').add(fieldMap);
        return result.id;
      } else {
        return snapshot.docs[0].id;
      }
    } catch (error) {
      print('Create group message error $error');
      return 'Error';
    }
  }

  getGroupMessage({String myUID}) {
    try {
      return _firebase
          .collection('GroupMessage')
          .where('MatchID', arrayContains: myUID)
          .snapshots();
    } catch (error) {
      print('Get group message error $error');
    }
  }

  updateRecentlyMessage({String docId, recentlyMapField}) {
    try {
      _firebase
          .collection('GroupMessage')
          .doc(docId)
          .update({"Recently": recentlyMapField});
    } catch (error) {
      print('Update recently message error $error');
    }
  }

  updateSeenInRecentlyMessage({String docId}) async {
    try {
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
    } catch (error) {
      print('Update seen in recently message $error');
    }
  }

  updateSeenInsideMessage(
      {String groupMessageDocId, String messageDocId}) async {
    try {
      await _firebase
          .collection('GroupMessage')
          .doc(groupMessageDocId)
          .collection('Messages')
          .doc(messageDocId)
          .update({'isSeen': true});
    } catch (error) {
      print('Update seen inside message $error');
    }
  }

  addMessage({String docId, messageMap}) async {
    try {
      return await _firebase
          .collection('GroupMessage')
          .doc(docId)
          .collection('Messages')
          .add(messageMap)
          .then((value) => value.id);
    } catch (error) {
      print(error);
      return null;
    }
  }

  getMessages({String docId}) {
    try {
      return _firebase
          .collection('GroupMessage')
          .doc(docId)
          .collection('Messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (error) {
      print('Get message error $error');
    }
  }
}
