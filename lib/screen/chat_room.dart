import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pks_mobile/controllers/database_controller.dart';
import 'package:pks_mobile/helper/constants.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseController databaseController = DatabaseController();
  var chatRoomStream = Rx<Stream>();
  var chatRoomMap = Rx<Map<String, dynamic>>();
  var userSnapshot = Rx<QuerySnapshot>();

  @override
  void initState() {
    super.initState();
    chatRoomStream.value =
        databaseController.getChatRoom(myUID: Constants.myUID.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List conversations'),
      ),
      body: Obx(
        () => chatRoomStream.value != null
            ? StreamBuilder<QuerySnapshot>(
                stream: chatRoomStream.value,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading...!"));
                  }

                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: ((context, index) {
                            return InkWell(
                              onTap: () {
                                Get.toNamed('/conversation',
                                    arguments: snapshot.data.docs[index]
                                        .data()['ChatRoomId']);
                              },
                              child: ListTile(
                                leading: Image.network(
                                    'https://www.kindpng.com/picc/m/24-248394_user-icon-hd-png-download.png'),
                                title: Text('Display Name'),
                              ),
                            );
                          }),
                        )
                      : Container(
                          child: Center(
                            child: Text('The chat room is empty!'),
                          ),
                        );
                },
              )
            : Container(
                child: Center(
                  child: Text('Nothing'),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/search_chat');
        },
        child: Icon(Icons.search_rounded),
      ),
    );
  }
}
