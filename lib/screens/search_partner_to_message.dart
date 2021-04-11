import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/ListTileUser.dart';

class SearchPartnerToMessage extends GetWidget<DbController> {
  final TextEditingController searchChat = TextEditingController();
  final userQuerySnapshot = Rx<QuerySnapshot>();

  final String _myEmail = Constants.myEmail.value;
  final String _myPhotoUrl = Constants.myPhotoUrl.value;
  final String _myUID = Constants.myUID.value;
  final String _myUsername = Constants.myUsername.value;

  onTabToCreateGroupMessage({DbController ctrl, int index}) async {
    Map<String, dynamic> myInfo = {
      "email": _myEmail,
      "photoUrl": _myPhotoUrl,
      "uid": _myUID,
      "username": _myUsername,
    };

    var partnerInfo = userQuerySnapshot.value.docs[index].data();
    partnerInfo.remove('filter'); //Remove filter out for insert to GroupMessage
    String partnerDeviceToken = partnerInfo.remove('deviceToken');

    if (myInfo['uid'] != partnerInfo['uid']) {
      String docId = await ctrl.createGroupMessage(
        partnerId: partnerInfo['uid'],
        fieldMap: {
          "Users": [myInfo, partnerInfo],
          "MatchID": [myInfo['uid'], partnerInfo['uid']],
          "Recently": {
            'seen': [myInfo['uid']],
            'sentAt': DateTime.now(),
            'message': 'Plz make a chat!'
          }
        },
      );
      if (docId != 'Error') {
        Map<String, dynamic> argumentData = {
          "docId": docId,
          "partnerDeviceToken": partnerDeviceToken,
          "partnerInfo": partnerInfo
        };
        await Get.toNamed(
          Routes.PRIVATE_MESSAGE,
          arguments: argumentData,
        );
      } else
        Get.snackbar('Error', 'Something went wrong');
    } else
      Get.snackbar('Stupid Error', 'You can not message to your self!',
          snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DbController>(
      initState: (_) {
        Constants.currentRoute.value = ModalRoute.of(context).settings.name;
      },
      builder: (ctrl) => SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black26),
                          child: TextField(
                            autofocus: true,
                            onChanged: (val) {
                              ctrl.getUserByUsername(filter: val).then((value) {
                                userQuerySnapshot.value = value;
                              });
                            },
                            controller: searchChat,
                            decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                hintText: 'Search ...',
                                hintStyle: TextStyle(color: Colors.black26),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ),
                Obx(() {
                  return userQuerySnapshot.value != null
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: userQuerySnapshot.value.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot _userQuerySnapshot =
                                userQuerySnapshot.value.docs[index];
                            return Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTileUser(
                                      leading:
                                          _userQuerySnapshot.get('photoUrl'),
                                      title: _userQuerySnapshot.get('username'),
                                      subTitle: _userQuerySnapshot.get('email'),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      onTabToCreateGroupMessage(
                                          ctrl: ctrl, index: index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blueAccent),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Text('Message'),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Text('Nothing'),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
