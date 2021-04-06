import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/widgets/ListTileUser.dart';

class GroupMessage extends GetWidget<DbController> {
  Widget listTileMessageGroup({QueryDocumentSnapshot groupMessageInfo}) {
    var unSeenMessage = groupMessageInfo.data()['Recently'];
    var partnerInfo = groupMessageInfo
        .data()['Users']
        .where((e) => e['uid'] != Constants.myUID.value)
        .toList();

    return InkWell(
      onTap: () {
        Get.toNamed('/private_message', arguments: {
          "docId": groupMessageInfo.id,
          "username": partnerInfo[0]['username'],
          "photoUrl": partnerInfo[0]['photoUrl'],
          "deviceTokens": partnerInfo[0]['deviceTokens'],
        });
      },
      child: ListTileUser(
        leading: partnerInfo[0]['photoUrl'],
        title: partnerInfo[0]['username'],
        subTitle: unSeenMessage['sentBy'] == Constants.myUID.value
            ? "You: ${unSeenMessage['message']}"
            : unSeenMessage['message'],
        subTitleDate: DateFormat.yMMMd()
            .add_jm()
            .format(unSeenMessage['sentAt'].toDate()),
        subTitleBold:
            unSeenMessage['seen'].any((val) => val == Constants.myUID.value)
                ? true
                : false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DbController>(
        initState: (_) {
          Constants.currentRoute.value = ModalRoute.of(context).settings.name;
        },
        dispose: (_) {},
        builder: (ctrl) => Scaffold(
              appBar: AppBar(
                title: Text('Group message'),
              ),
              body: ctrl.getGroupMessage(myUID: Constants.myUID.value) != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream:
                          ctrl.getGroupMessage(myUID: Constants.myUID.value),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text("Loading...!"));
                        } else if (snapshot.hasData) {
                          return snapshot.data.docs.length == 0
                              ? Container(
                                  child: Center(
                                    child: Text('The chat room is empty!'),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: ((context, index) {
                                    return listTileMessageGroup(
                                        groupMessageInfo:
                                            snapshot.data.docs[index]);
                                  }),
                                );
                        } else {
                          return null;
                        }
                      },
                    )
                  : Text('No work'),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.toNamed('/search_private_message');
                },
                child: Icon(Icons.search_rounded),
              ),
            ));
  }
}
