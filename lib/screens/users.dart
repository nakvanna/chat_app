import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/widgets/screen_background_color.dart';

class Users extends GetWidget<DbController> {
  final TextEditingController _filter = TextEditingController(text: '');
  final isSelected = false.obs;

  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<DbController>(
      builder: (ctrl) => SafeArea(
        child: screenBackgroundColor(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightBlueAccent, Colors.purple],
          scaffold: Scaffold(
            backgroundColor: Colors.transparent,
            body: StreamBuilder(
              stream: ctrl.getUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var _userInfo = Rx<List<QueryDocumentSnapshot>>();
                  _userInfo.value = snapshot.data.docs;
                  print(_userInfo.runtimeType);

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
                            onPressed: () {},
                            child: Text(
                              'Next',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                        title: Text('Select your members'),
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
                            padding: EdgeInsets.only(top: 50),
                            child: Container(
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
                                controller: _filter,
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
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            var userInfo = _userInfo.value[index].data();
                            userInfo.putIfAbsent('isChecked', () => true);

                            return CheckboxListTile(
                              secondary: userInfo['photoUrl'] == ""
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
                              value: userInfo['isChecked']
                                  ? isSelected.value
                                  : false,
                              onChanged: (bool value) {
                                userInfo['isChecked'] = value;
                                print(userInfo);
                              },
                            );
                          }, childCount: _userInfo.value.length),
                        ),
                      )
                    ],
                  );
                } else {
                  return Text(
                    'empty'.tr,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
