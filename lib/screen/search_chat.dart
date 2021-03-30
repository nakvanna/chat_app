import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/database_controller.dart';
import 'package:pks_mobile/helper/constants.dart';

class SearchChat extends GetWidget {
  DatabaseController databaseController = DatabaseController();
  TextEditingController searchChat = TextEditingController();

  var getUsernameQuerySnapshot = Rx<QuerySnapshot>();
  var getChatRoomExistQuerySnapshot = Rx<QuerySnapshot>();

  createChatRoom(int index) async {
    String myUID = Constants.myUID.value;
    String myEmail = Constants.myEmail.value;
    String myUsername = Constants.myUsername.value;
    String myPhotoUrl = Constants.myPhotoUrl.value;
    String partnerUID =
        await getUsernameQuerySnapshot.value.docs[index].get('uid');
    String partnerUsername =
        await getUsernameQuerySnapshot.value.docs[index].get('username');
    String partnerEmail =
        await getUsernameQuerySnapshot.value.docs[index].get('email');
    String partnerPhotoUrl =
        await getUsernameQuerySnapshot.value.docs[index].get('photoUrl');
    await databaseController.createChatRoom(
        chatRoomId: '${myUsername}_$partnerUsername',
        chatRoomMap: {
          "ChatRoomId": "${myUsername}_$partnerUsername",
          "Users": [myUID, partnerUID]
        },
        partnerName: partnerUsername);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          onChanged: (val) {
                            databaseController
                                .getUserByUsername(val)
                                .then((value) {
                              getUsernameQuerySnapshot.value = value;
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
              Obx(() => getUsernameQuerySnapshot.value != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: getUsernameQuerySnapshot.value.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: Image.network(
                                    'https://www.kindpng.com/picc/m/24-248394_user-icon-hd-png-download.png'),
                                title: Text(getUsernameQuerySnapshot
                                    .value.docs[index]
                                    .get('username')),
                                subtitle: Text(getUsernameQuerySnapshot
                                    .value.docs[index]
                                    .get('email')),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                createChatRoom(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
