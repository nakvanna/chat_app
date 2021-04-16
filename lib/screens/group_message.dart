import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/helper/custom_font_style.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/ListTileUser.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class GroupMessage extends GetWidget<DbController> {
  final CustomFontStyle customFontStyle = CustomFontStyle();
  final String _myUID = Constants.myUID.value;

  Widget listTileMessageGroup(
      {DbController ctrl, QueryDocumentSnapshot groupMessageInfo}) {
    var lastMessage = groupMessageInfo.data()['Recently'];
    var partnerInfo = groupMessageInfo
        .data()['Users']
        .where((e) => e['uid'] != Constants.myUID.value)
        .toList()[0];

    return InkWell(
      onTap: () {
        ctrl.getUserByUID(partnerInfo['uid']).then((value) async {
          String partnerDeviceToken = await value.docs[0].data()['deviceToken'];

          Map<String, dynamic> argumentData = {
            "docId": groupMessageInfo.id,
            "partnerDeviceToken": partnerDeviceToken,
            "partnerInfo": partnerInfo
          };
          await Get.toNamed(
            Routes.PRIVATE_MESSAGE,
            arguments: argumentData,
          );
        });
      },
      child: ListTileUser(
        leading: partnerInfo['photoUrl'],
        title: partnerInfo['username'],
        subTitle: lastMessage['sentBy'] == _myUID
            ? "You: ${lastMessage['message']}"
            : lastMessage['message'],
        subTitleDate:
            DateFormat.yMMMd().add_jm().format(lastMessage['sentAt'].toDate()),
        subTitleBold:
            lastMessage['seen'].any((val) => val == _myUID) ? true : false,
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
      builder: (ctrl) {
        return screenBackgroundColor(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightBlueAccent, Colors.purple],
          scaffold: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'messages'.tr,
                style: customFontStyle.appBarTitleTextStyle(),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.GROUP_CREATOR);
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: ctrl.getGroupMessage(myUID: _myUID),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'error occurred'.tr,
                    style: customFontStyle.labelTextStyle(),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: Text(
                      "loading".tr,
                      style: customFontStyle.labelTextStyle(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data.docs.length == 0
                      ? Container(
                          child: Center(
                            child: Text(
                              'empty'.tr,
                              style: customFontStyle.labelTextStyle(),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: ((context, index) {
                            return listTileMessageGroup(
                                ctrl: ctrl,
                                groupMessageInfo: snapshot.data.docs[index]);
                          }),
                        );
                } else {
                  return Text(
                    'empty'.tr,
                    style: customFontStyle.labelTextStyle(),
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 20,
              backgroundColor: Colors.purple[400],
              onPressed: () {
                Get.toNamed(Routes.SEARCH_PARTNER_TO_MESSAGE);
              },
              child: Icon(Icons.search_rounded),
            ),
          ),
        );
      },
    );
  }
}
