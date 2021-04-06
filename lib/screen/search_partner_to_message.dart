import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/widgets/ListTileUser.dart';

class SearchPartnerToMessage extends GetWidget<DbController> {
  final searchChat = TextEditingController();
  final getUsernameQuerySnapshot = Rx<QuerySnapshot>();
  final getChatRoomExistQuerySnapshot = Rx<QuerySnapshot>();

  onTabToCreateGroupMessage({DbController ctrl, int index}) async {
    String myDeviceToken = await FirebaseMessaging.instance.getToken();
    Map<String, dynamic> myInfo = {
      "email": Constants.myEmail.value,
      "photoUrl": Constants.myPhotoUrl.value,
      "uid": Constants.myUID.value,
      "username": Constants.myUsername.value,
      "deviceTokens": [myDeviceToken],
    };
    var partnerInfo = getUsernameQuerySnapshot.value.docs[index].data();
    if (myInfo['uid'] != partnerInfo['uid']) {
      await ctrl.createGroupMessage(
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
          deviceTokens: partnerInfo['tokenNotification']);
    } else {
      Get.snackbar('Stupid Error', 'You can not message to your self!',
          snackPosition: SnackPosition.BOTTOM);
    }
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
                                    ctrl
                                        .getUserByUsername(filter: val)
                                        .then((value) {
                                      getUsernameQuerySnapshot.value = value;
                                    });
                                  },
                                  controller: searchChat,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.search),
                                      hintText: 'Search ...',
                                      hintStyle:
                                          TextStyle(color: Colors.black26),
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
                      Obx(
                        () => getUsernameQuerySnapshot.value != null
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    getUsernameQuerySnapshot.value.docs.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTileUser(
                                          leading: getUsernameQuerySnapshot
                                              .value.docs[index]
                                              .get('photoUrl'),
                                          title: getUsernameQuerySnapshot
                                              .value.docs[index]
                                              .get('username'),
                                          subTitle: getUsernameQuerySnapshot
                                              .value.docs[index]
                                              .get('email'),
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
                                  ));
                                },
                              )
                            : Container(
                                child: Text('Nothing'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
