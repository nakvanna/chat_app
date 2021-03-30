import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/helper/constants.dart';

class DatabaseController {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .get();
  }

  Future<QuerySnapshot> getUserByUID(String uid) async {
    QuerySnapshot snapshot;
    snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .get();
    return snapshot;
  }

  getUsernameByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> checkBeforeUploadUserInfo(String uid) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .get();
  }

  Future<void> uploadUserInfo(userMap) async {
    QuerySnapshot snapshot;
    try {
      snapshot = await checkBeforeUploadUserInfo(userMap['uid']);
      if (snapshot.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('Users').add(userMap);
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future<QuerySnapshot> checkBeforeCreateChatRoom(
      String myUsername, String partnerName) {
    return FirebaseFirestore.instance.collection('ChatRoom').where('ChatRoomId',
        whereIn: [
          '${myUsername}_$partnerName',
          '${partnerName}_$myUsername'
        ]).get();
  }

  Future<void> createChatRoom(
      {String chatRoomId, chatRoomMap, String partnerName}) async {
    QuerySnapshot snapshotCheckChatRoom;
    try {
      snapshotCheckChatRoom = await checkBeforeCreateChatRoom(
          Constants.myUsername.value, partnerName);
      if (snapshotCheckChatRoom.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(chatRoomId)
            .set(chatRoomMap);
        Get.toNamed('/conversation', arguments: chatRoomId);
      }
    } catch (e) {
      print(e);
    }
  }

  getChatRoom({String myUID}) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('Users', arrayContains: Constants.myUID.value)
        .snapshots();
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .add(messageMap);
  }

  getConversationMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .orderBy('timesteam', descending: true)
        .snapshots();
  }
}
