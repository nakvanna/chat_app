import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/routes/app_pages.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class SearchPartnerToMessage extends GetWidget<DbController> {
  final TextEditingController searchChat = TextEditingController();
  final userQuerySnapshot = Rx<QuerySnapshot>();

  final String _myEmail = Constants.myEmail.value;
  final String _myPhotoUrl = Constants.myPhotoUrl.value;
  final String _myUID = Constants.myUID.value;
  final String _myUsername = Constants.myUsername.value;

  onTabToCreateGroupMessage(
      {DbController ctrl, int index, Map<String, dynamic> partnerInfo}) async {
    Map<String, dynamic> myInfo = {
      "email": _myEmail,
      "photoUrl": _myPhotoUrl,
      "uid": _myUID,
      "username": _myUsername,
    };

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
      builder: (ctrl) => screenBackgroundColor(
        scaffold: Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream: ctrl.getUsers(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                var _userInfo = Rx<List<QueryDocumentSnapshot>>();
                _userInfo.value = snapshot.data.docs;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'cancel',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                      title: Text('new message'),
                      centerTitle: true,
                      floating: true,
                      pinned: true,
                      elevation: 20,
                      expandedHeight: 100,
                      shadowColor: Colors.black,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(top: 100),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              onChanged: (val) {
                                if (val != '') {
                                  _userInfo.value = snapshot.data.docs
                                      .where((element) =>
                                          element
                                              .data()['username']
                                              .toString()
                                              .toLowerCase() ==
                                          val.toLowerCase())
                                      .toList();
                                } else {
                                  _userInfo.value = snapshot.data.docs;
                                }
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
                      ),
                    ),
                    Obx(
                      () => SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          var userInfo = _userInfo.value[index].data();
                          userInfo.putIfAbsent('isChecked', () => true);

                          return ListTile(
                            trailing: IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                print(_userInfo.value[index].data());
                                onTabToCreateGroupMessage(
                                    ctrl: ctrl,
                                    index: index,
                                    partnerInfo: _userInfo.value[index].data());
                              },
                            ),
                            leading: userInfo['photoUrl'] == ""
                                ? Image.asset(
                                    'assets/images/account_image.png',
                                    width: 30,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userInfo['photoUrl']),
                                  ),
                            title: Text(userInfo['username']),
                            subtitle: Text(userInfo['email']),
                          );
                        }, childCount: _userInfo.value.length),
                      ),
                    )
                  ],
                );
              } else
                return Text(
                  'empty'.tr,
                );
            },
          ),
        ),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.lightBlueAccent, Colors.purple],
      ),
    );
  }
}
