import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/db_controller.dart';

class Users extends GetWidget<DbController> {
  final isSelected = false.obs;

  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<DbController>(
      builder: (ctrl) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlueAccent, Colors.purple],
            ),
          ),
          child: Scaffold(
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
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
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
                            padding: EdgeInsets.only(top: 50),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: TextField(
                                onChanged: (val) {},
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
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          var userInfo = snapshot.data.docs[index].data();
                          userInfo.putIfAbsent('isChecked', () => true);

                          return Obx(
                            () => CheckboxListTile(
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
                            ),
                          );
                        }, childCount: snapshot.data.docs.length),
                      ),
                    ],
                  );
                } else {
                  return Text('Nothing here...');
                }
              },
              /*child: CustomScrollView(
                slivers: [
                  ctrl.getGroupMessage(myUID: Constants.myUID.value) != null
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
                            }
                            return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: ((context, index) {
                                return Text('Hello');
                              }),
                            );
                          },
                        )
                      : Text('No work'),*/ /*
                ],
              ),*/
            ),
          ),
        ),
      ),
    );
  }
}
